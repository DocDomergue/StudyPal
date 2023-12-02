/**
 Main view file for UVM StudyPal. Defines the page flow for the app.
 Includes a preview structure for previewing in XCode.
 */

import SwiftUI
import Combine

// Global Constants
let CURRENT_DATE = Date()
let CALENDAR = Calendar.current
let FALL_SEMESTER_START = Calendar.current.date(from: DateComponents(year: CALENDAR.component(.year, from: CURRENT_DATE), month: 8, day: 28))!
let FALL_SEMESTER_END = Calendar.current.date(from: DateComponents(year: CALENDAR.component(.year, from: CURRENT_DATE), month: 12, day: 15))!
let SPRING_SEMESTER_START = Calendar.current.date(from: DateComponents(year: CALENDAR.component(.year, from: CURRENT_DATE), month: 1, day: 15))!
let SPRING_SEMESTER_END = Calendar.current.date(from: DateComponents(year: CALENDAR.component(.year, from: CURRENT_DATE), month: 5, day: 10))!


// Holds some functions for using the CAS webauth on login
class AuthViewModel: ObservableObject {
    @Published var loggedIn: Bool = false
    
    func logIn() {
        self.loggedIn = true
    }
    
    func logOut() {
        WebView.clearCookies {
            DispatchQueue.main.async {
                self.loggedIn = false
            }
        }
    }
}

// Overhead to prevent access to the rest of the app before proper authentication
struct ContentView: View {
    @StateObject var viewModel = AuthViewModel()
    
    var body: some View {
        NavigationView {
            if !viewModel.loggedIn {
                LoginView(viewModel: viewModel)
                
                
            } else {
                MainPageView(viewModel: viewModel)
                    .environmentObject(User())
                
            }
        }
    }
    
    
    
}

// Main view structure
struct MainPageView: View {
    @State var openTab = 0
    @ObservedObject var viewModel: AuthViewModel
    @EnvironmentObject var user: User
    
    @State var firstPull = true
    
    func menuChangePull() {
        user.pullUserProfile()
    }
    
    func menuChangePush() {
        user.push { success, error in
            if success {
                print("User data pushed successfully")
            } else if let error = error {
                print("Error pushing user data: \(error)")
            }
        }
    }
    
    // Code for the horizontal navigation buttons at the bottom. One button for each of 4 tabs
    var body: some View {
        NavigationStack {
            TabView(selection: $openTab) {
                CalendarPage()
                    .tabItem() {
                        Image(systemName: "calendar")
                    }
                    .tag(0)
                
                ToDoPage(user: _user)
                    .tabItem() {
                        Image(systemName: "list.bullet")
                    }
                    .tag(1)
                
                TimerPage(user: _user)
                    .tabItem() {
                        Image(systemName: "stopwatch")
                    }
                    .tag(2)
                
                StatsPage(user: _user)
                    .tabItem() {
                        Image(systemName: "chart.pie")
                    }
                    .tag(3)
                
                // Also contains the header and other top items of the UI
            } 
            .onAppear {
                if firstPull {
                    menuChangePull()
                    firstPull = false
                }// Initial Pull
            }
            .toolbar {
                if openTab == 0 {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Menu {
                            NavigationLink("Add Course") {
                                CourseListPage(user:  _user).navigationTitle("All Courses").onDisappear { menuChangePush() }
                            }
                            NavigationLink("Add Study Block") {
                                StudyBlockPage(user:  _user).navigationTitle("New Study Block").onDisappear { menuChangePush() }
                            }
                            NavigationLink("Add Custom Event") {
                                CustomItemPage(user:  _user).navigationTitle("New Custom Event").onDisappear { menuChangePush() }
                            }
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
                /* This is temporary. I'm thinking something more like a modal popping up when the user presses the user icon. Entirely new page might be tedius.*/
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(role: .destructive, action: { viewModel.logOut() }) {
                            Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                        Button("Push User Data") {
                            user.push { success, error in
                                if success {
                                    print("User data pushed successfully")
                                } else if let error = error {
                                    print("Error pushing user data: \(error)")
                                }
                            }
                        }
                        Button("Clear Data") {
                            user.clearData { success, error in
                                if success {
                                    print("User data pushed successfully")
                                } else if let error = error {
                                    print("Error pushing user data: \(error)")
                                }
                            }
                        }
                        Button("Pull Data") {
                            user.pullUserProfile()
                        }
                    } label: {
                        Image(systemName: "person.crop.circle.fill")
                    }
                }
            }
        }
    }
}


// Login window creates a browser view and goes to the webauth portal running through our server
struct LoginView: View {
    @State private var shouldShowWebView = true
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if shouldShowWebView {
                WebView(url: URL(string: "https://one.ehinchli.w3.uvm.edu")!) { _ in
                    viewModel.logIn()
                }
            } else {
                MainPageView(viewModel: viewModel)
            }
        }
    }
}

// Structs to hold some calendar specific calls, variables, and functions
struct CalendarPageView: View {
    var username: String
    
    var body: some View {
        Text("Welcome, \(username)! This is your calendar.")
    }
}

// View of the actual calendar grid itself
struct CalendarPage: View {
    var body: some View {
        CalendarView()
            .environmentObject(CalendarManager())
    }
    
    
}

// When the course list is open, this is the display on screen
struct CourseListPage: View {
    @State private var queryString: String = ""
    @State private var courses: [Course] = []
    @State private var userCourses: [Course] = []
    @State private var cancellables = Set<AnyCancellable>()
    @State private var selectedCourses: [Course] = []
    @EnvironmentObject var user: User
    
    func menuChangePull() {
        user.pullUserProfile()
    }
    
    func menuChangePush() {
        user.push { success, error in
            if success {
                print("User data pushed successfully")
            } else if let error = error {
                print("Error pushing user data: \(error)")
            }
        }
    }
    
    var body: some View {
        VStack(){
            
            List(selectedCourses, id: \.id) { course in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(course.subj) \(course.course_number) \(course.section)").font(.headline)
                        Text(course.title).font(.subheadline)
                        Text(course.instructor)
                        if let startTime = course.start_time, let endTime = course.end_time {
                            Text("Time: \(startTime) - \(endTime)").font(.footnote)
                            Text("Days: \(course.days.trimmingCharacters(in: .whitespacesAndNewlines))").font(.footnote)
                        } else {
                            Text("Time: N/A").font(.footnote)
                        }
                        Text("Credits: \(course.credits)").font(.footnote)
                    }
                    .padding(.vertical, 4)
                    Spacer()
                    
                    Button(action: {
                        toggleCourseSelection(course: course)
                    }) {
                        Image(systemName: courseIsSelected(course: course) ? "checkmark.circle.fill" : "plus.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(courseIsSelected(course: course) ? .green : .blue)
                    }
                }
            }.frame(maxHeight: 200)
                .onAppear {
                    selectedCourses = user.courses
                }
            
            TextField("Search Courses", text: $queryString)
                .padding(.horizontal)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: queryString) { newValue in
                    searchCourses()
                    userCourses = user.courses
                    selectedCourses = user.courses
                }.onAppear {
                    userCourses = user.courses
                    selectedCourses = user.courses
                }
            
            List(courses, id: \.id) { course in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(course.subj) \(course.course_number) \(course.section)").font(.headline)
                        Text(course.title).font(.subheadline)
                        Text(course.instructor)
                        if let startTime = course.start_time, let endTime = course.end_time {
                            Text("Time: \(startTime) - \(endTime)").font(.footnote)
                            Text("Days: \(course.days.trimmingCharacters(in: .whitespacesAndNewlines))").font(.footnote)
                        } else {
                            Text("Time: N/A").font(.footnote)
                        }
                        Text("Credits: \(course.credits)").font(.footnote)
                    }
                    .padding(.vertical, 4)
                    Spacer()
                    
                    Button(action: {
                        toggleCourseSelection(course: course)
                    }) {
                        Image(systemName: courseIsSelected(course: course) ? "checkmark.circle.fill" : "plus.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(courseIsSelected(course: course) ? .green : .blue)
                    }
                }
            }
        } .onDisappear {
            
            menuChangePush()
        }
    }
    
    // Function behind the search bar, works with our scraped SOC
    func searchCourses() {
        if queryString.isEmpty {
            self.courses = []
            return
        }
        
        if queryString.count == 1 {
            return
        }
        
        NetworkManager.shared.fetchCourses(query: queryString) { courses, error in
            DispatchQueue.main.async {
                if let courses = courses {
                    self.courses = courses
                } else if let error = error {
                    print("Error fetching courses: \(error)")
                }
            }
        }
    }
    
    // Function to add a course to your profile
    func courseIsSelected(course: Course) -> Bool {
        return selectedCourses.contains(where: { $0.id == course.id })
    }
    
    // Function that handles the add/added button
    func toggleCourseSelection(course: Course) {
        
        selectedCourses = user.courses
        
        if courseIsSelected(course: course) {
            removeCourse(course: course)
        } else {
            addCourse(course: course)
        }
    }
    
    // Function that actually adds the course to internal structures
    func addCourse(course: Course) {
        user.courses.append(course)
        selectedCourses.append(course)
    }
    
    // Function that actually removes the course from internal structures
    func removeCourse(course: Course) {
        user.courses = user.courses.filter { $0.id != course.id }
        selectedCourses = selectedCourses.filter { $0.id != course.id }
    }
}






// When the course list is open, this is the display on screen
struct StudyBlockPage: View {
    @State private var nameString: String = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var startDateComponents = DateComponents()
    @State private var endDateComponents = DateComponents()
    @State private var selectedCourse: Course?
    @State private var finalCourse: Course = Course(subj: "No ", course_number: "Course", title: "Empty", section: "Empty", instructor: "Empty", start_time: "Empty", end_time: "Empty", days: "Empty", bldg: "Empty", room: "Empty", credits: "Empty", xlistings: "Empty", lec_lab: "Empty", coll_code: "Empty", max_enrollment: 0, current_enrollment: 0, comp_numb: 0, id: 1243657, email: "Empty")
    @State private var userEvents: [StudyItem] = []
    @State private var selectedEvents: [StudyItem] = []
    @EnvironmentObject var user: User
    
    func menuChangePull() {
        user.pullUserProfile()
    }
    
    func menuChangePush() {
        user.push { success, error in
            if success {
                print("User data pushed successfully")
            } else if let error = error {
                print("Error pushing user data: \(error)")
            }
        }
    }
    
    var body: some View {
        VStack(){
            Text("Current Study Blocks:")
            List(selectedEvents) { StudyItem in
                HStack {
                    VStack(alignment: .leading) {
                        Text(StudyItem.name)
                        Text("\(StudyItem.course.subj) \(StudyItem.course.course_number)").font(.headline)
                    }
                    .padding(.vertical, 4)
                    Spacer()
                    
                    Button(action: {
                        removeStudyItem(studyItem: StudyItem)
                    }) {
                        Image(systemName: "trash.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.accentColor)
                    }
                }
            }.frame(maxHeight: 200)
                .onAppear {
                    selectedEvents = user.study
                }
                .onDisappear {
                    menuChangePush()
                }
            
            TextField("Study Block Name", text: $nameString)
                .padding(.horizontal)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Spacer()
            
            Text("Associate a course?")
            
            Spacer()
            
            if user.courses.isEmpty {
                Text("No courses available")
            } else {
                List(user.courses) { course in
                    Button(action: {
                        selectedCourse = course
                    }) {
                        Text("\(course.subj) \(course.course_number)").foregroundColor(course == selectedCourse ? .accentColor : .primary)
                    }
                }
            }
            
            Spacer()
            
            DatePicker("Select Date and Start Time", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(CompactDatePickerStyle())
            
            DatePicker("Select End Time", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(CompactDatePickerStyle())
            Spacer()
            
            Button(action: {
                startDateComponents = Calendar.current.dateComponents([.calendar, .era, .year, .month, .day], from: startDate)
                endDateComponents = Calendar.current.dateComponents([.calendar, .era, .year, .month, .day], from: startDate)
        
                finalCourse = selectedCourse ?? finalCourse
                
                addStudyItem(nameString, finalCourse, startDateComponents, endDateComponents)
            }) {
                Text("Add Study Block")
                    .foregroundColor(.black)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(20)
            }
        }
    }
        
        
    func addStudyItem(_ name: String, _ course: Course, _ startTime: DateComponents, _ endTime: DateComponents) {
        user.study.append(StudyItem(name: name, course: course, startTime: startTime, endTime: endTime))
        selectedEvents = user.study
    }

    
    // Function that actually removes the course from internal structures
    func removeStudyItem(studyItem: StudyItem) {
        user.study = user.study.filter { $0.name != studyItem.name }
        selectedEvents = selectedEvents.filter { $0.name != studyItem.name }
    }
}




// When the course list is open, this is the display on screen
struct CustomItemPage: View {
    @State private var queryString: String = ""
    @State private var courses: [Course] = []
    @State private var userCourses: [Course] = []
    @State private var cancellables = Set<AnyCancellable>()
    @State private var selectedCourses: [Course] = []
    @EnvironmentObject var user: User
    
    func menuChangePull() {
        user.pullUserProfile()
    }
    
    func menuChangePush() {
        user.push { success, error in
            if success {
                print("User data pushed successfully")
            } else if let error = error {
                print("Error pushing user data: \(error)")
            }
        }
    }
    
    var body: some View {
        VStack(){
            
            List(selectedCourses, id: \.id) { course in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(course.subj) \(course.course_number) \(course.section)").font(.headline)
                        Text(course.title).font(.subheadline)
                        Text(course.instructor)
                        if let startTime = course.start_time, let endTime = course.end_time {
                            Text("Time: \(startTime) - \(endTime)").font(.footnote)
                            Text("Days: \(course.days.trimmingCharacters(in: .whitespacesAndNewlines))").font(.footnote)
                        } else {
                            Text("Time: N/A").font(.footnote)
                        }
                        Text("Credits: \(course.credits)").font(.footnote)
                    }
                    .padding(.vertical, 4)
                    Spacer()
                    
                    Button(action: {
                        toggleCourseSelection(course: course)
                    }) {
                        Image(systemName: courseIsSelected(course: course) ? "checkmark.circle.fill" : "plus.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(courseIsSelected(course: course) ? .green : .blue)
                    }
                }
            }.frame(maxHeight: 200)
                .onAppear {
                    selectedCourses = user.courses
                }
            
            TextField("Search Courses", text: $queryString)
                .padding(.horizontal)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: queryString) { newValue in
                    searchCourses()
                    userCourses = user.courses
                    selectedCourses = user.courses
                }.onAppear {
                    userCourses = user.courses
                    selectedCourses = user.courses
                }
            
            List(courses, id: \.id) { course in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(course.subj) \(course.course_number) \(course.section)").font(.headline)
                        Text(course.title).font(.subheadline)
                        Text(course.instructor)
                        if let startTime = course.start_time, let endTime = course.end_time {
                            Text("Time: \(startTime) - \(endTime)").font(.footnote)
                            Text("Days: \(course.days.trimmingCharacters(in: .whitespacesAndNewlines))").font(.footnote)
                        } else {
                            Text("Time: N/A").font(.footnote)
                        }
                        Text("Credits: \(course.credits)").font(.footnote)
                    }
                    .padding(.vertical, 4)
                    Spacer()
                    
                    Button(action: {
                        toggleCourseSelection(course: course)
                    }) {
                        Image(systemName: courseIsSelected(course: course) ? "checkmark.circle.fill" : "plus.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(courseIsSelected(course: course) ? .green : .blue)
                    }
                }
            }
        } .onDisappear {
            
            menuChangePush()
        }
    }
    
    // Function behind the search bar, works with our scraped SOC
    func searchCourses() {
        if queryString.isEmpty {
            self.courses = []
            return
        }
        
        if queryString.count == 1 {
            return
        }
        
        NetworkManager.shared.fetchCourses(query: queryString) { courses, error in
            DispatchQueue.main.async {
                if let courses = courses {
                    self.courses = courses
                } else if let error = error {
                    print("Error fetching courses: \(error)")
                }
            }
        }
    }
    
    // Function to add a course to your profile
    func courseIsSelected(course: Course) -> Bool {
        return selectedCourses.contains(where: { $0.id == course.id })
    }
    
    // Function that handles the add/added button
    func toggleCourseSelection(course: Course) {
        
        selectedCourses = user.courses
        
        if courseIsSelected(course: course) {
            removeCourse(course: course)
        } else {
            addCourse(course: course)
        }
    }
    
    // Function that actually adds the course to internal structures
    func addCourse(course: Course) {
        user.courses.append(course)
        selectedCourses.append(course)
    }
    
    // Function that actually removes the course from internal structures
    func removeCourse(course: Course) {
        user.courses = user.courses.filter { $0.id != course.id }
        selectedCourses = selectedCourses.filter { $0.id != course.id }
    }
}








// View for the To-Do page
struct ToDoPage: View {
    @State private var tasks: [TaskItem] = []
    @State private var newTask: String = ""
    
    @EnvironmentObject var user: User
    
    func menuChangePull() {
        user.pullUserProfile()
    }
    
    func menuChangePush() {
        user.push { success, error in
            if success {
                print("User data pushed successfully")
            } else if let error = error {
                print("Error pushing user data: \(error)")
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(tasks) { task in
                        HStack {
                            Button(action: {
                                toggleTaskCompletion(task)
                            }) {
                                Image(systemName: task.isCompleted ? "checkmark.square" : "square")
                                    .imageScale(.large)
                                    .foregroundColor(task.isCompleted ? .accentColor : .gray)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Text(task.name)
                                .strikethrough(task.isCompleted)
                                .foregroundColor(task.isCompleted ? .gray : .primary)
                        }
                    }
                    .onDelete(perform: deleteTask)
                }
                
                HStack {
                    TextField("Type here", text: $newTask, onCommit: addTaskOnCommit)
                    Button(action: addTask) {
                        Text("Add Task")
                    }
                }
                .padding()
            }
            .navigationTitle("To-Do List")
        } 
        .onAppear() {
            tasks = user.todo
        }
        .onDisappear {
            user.todo = tasks
            menuChangePush()
        }
    }
    
    // Some functions to handle the different keystrokes possible to submit a task
    func addTaskOnCommit() {
        addTask()
    }
    func addTask() {
        if !newTask.isEmpty {
            tasks.append(TaskItem(name: newTask))
            newTask = ""
        }
    }
    
    // Function that deletes tasks
    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
    
    // Function that updates the text to show a done verses yet to do task
    func toggleTaskCompletion(_ task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
}

// Timer view page, most of its internals are in TimerViewModel.swift for organization
struct TimerPage: View {
    
    // Create a timer object
    @StateObject var viewModel = TimerViewModel()
    
    @EnvironmentObject var user: User
    
    func menuChangePull() {
        user.pullUserProfile()
    }
    
    func menuChangePush() {
        user.push { success, error in
            if success {
                print("User data pushed successfully")
            } else if let error = error {
                print("Error pushing user data: \(error)")
            }
        }
    }
    
    // Display code to create the visuals
    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.currentState == .work ? "Work" : (viewModel.currentState == .shortBreak ? "Short Break" : "Long Break"))
                .font(.largeTitle)
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 15)
                    .opacity(0.3)
                    .foregroundColor(Color(hue: 0.114, saturation: 1.0, brightness: 1.0))
                
                Circle()
                    .trim(from: 0, to: CGFloat(1.0 - Double(viewModel.remainingSeconds) / Double(viewModel.currentState == .work ? viewModel.workDuration : (viewModel.currentState == .shortBreak ? viewModel.shortBreakDuration : viewModel.longBreakDuration))))
                    .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round))
                    .rotationEffect(Angle(degrees: -90))
                    .foregroundColor(.accentColor)
                
                Text("\(viewModel.remainingSeconds / 60):\(String(format: "%02d", viewModel.remainingSeconds % 60))")
                    .font(.largeTitle)
            }
            .frame(width: 200, height: 200)
            
            // Switch that uses the buttons to control the state of our timer
            switch viewModel.userActionState {
            case .notStarted:
                Button("Start") {
                    viewModel.startTimer()
                    user.studyStat+=15
                }
                
            case .running:
                HStack(spacing: 20) {
                    Button("Pause") {
                        viewModel.pauseTimer()
                    }
                    Button("Reset") {
                        viewModel.resetTimer()
                    }
                    Button("Advance") {
                        viewModel.advanceTimer()
                    }
                }
                
            case .paused:
                HStack(spacing: 20) {
                    Button("Resume") {
                        viewModel.resumeTimer()
                    }
                    Button("Reset") {
                        viewModel.resetTimer()
                    }
                }
            }
        }
        .padding()
        .onDisappear {
            menuChangePush()
        }
    }
}

// Stats page that is used to gamify being a good student.
struct StatsPage: View {
    
    // Variables that are shown on the page
    @State private var semesterCompletion: Double = 100 * calculateSemesterPercentage()
    @State private var studyTimeInMinutes: Int = 0
    @State private var averageStudyTime: Int = 50
    
    @EnvironmentObject var user: User
    
    func menuChangePull() {
        user.pullUserProfile()
    }
    
    func menuChangePush() {
        user.push { success, error in
            if success {
                print("User data pushed successfully")
            } else if let error = error {
                print("Error pushing user data: \(error)")
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Statistics")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Text("Semester Completion")
                .font(.title)
                .padding()
            
            Text("\(semesterCompletion, specifier: "%.1f")%")
            
            ProgressView(value: semesterCompletion, total: 100)
                .padding()
            
            Text("Time Spent Studying")
                .font(.title)
                .padding()
                .onAppear {
                    studyTimeInMinutes = user.studyStat
                }
            
            Text("\(studyTimeInMinutes) minutes")
                .font(.headline)
                .padding()
            
            Divider()
            
            Text("Global Stats")
                .font(.title)
                .padding()
            
            Text("Average Time Spent Studying")
                .font(.title2)
                .padding()
                .onAppear {
                    averageStudyTime = Int(Double(user.studyStat * 2)/1.5)
                }
            
            Text("\(averageStudyTime) minutes")
             .font(.headline)
             .padding()
        }
        .navigationTitle("Statistics")
        .onDisappear {
            menuChangePush()
        }
    }
}

// Approximated semester % calculator
func calculateSemesterPercentage() -> Double {
    
    let percentage: Double
    
    if CURRENT_DATE >= FALL_SEMESTER_START && CURRENT_DATE <= FALL_SEMESTER_END {
        let daysInRange = CURRENT_DATE.daysBetweenDate(FALL_SEMESTER_START, andDate: FALL_SEMESTER_END)
        let daysPassed = CURRENT_DATE.daysBetweenDate(FALL_SEMESTER_START, andDate: CURRENT_DATE)
        percentage = Double(daysPassed) / Double(daysInRange)
    } else if CURRENT_DATE >= SPRING_SEMESTER_START && CURRENT_DATE <= SPRING_SEMESTER_END {
        let daysInRange = CURRENT_DATE.daysBetweenDate(SPRING_SEMESTER_END, andDate: SPRING_SEMESTER_END)
        let daysPassed = CURRENT_DATE.daysBetweenDate(SPRING_SEMESTER_END, andDate: CURRENT_DATE)
        percentage = Double(daysPassed) / Double(daysInRange)
    } else {
        percentage = 100.0
    }
    
    return percentage
}

// Tiemr requires a small function added to the built in Date object
extension Date {
    func daysBetweenDate(_ startDate: Date, andDate endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return components.day ?? 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // Previewing ContentView
        ContentView(viewModel: AuthViewModel())
        
        // Or, if you want to specifically preview MainPageView with a logged-in state
        //        MainPageView(viewModel: AuthViewModel())
    }
}


