/**
 Main view file for UVM StudyPal. Defines the page flow for the app.
 Includes a preview structure for previewing in XCode.
 */

import SwiftUI
import Combine

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
            }
        }
    }
}

// Main view structure
struct MainPageView: View {
    @State var openTab = 0
    @ObservedObject var viewModel: AuthViewModel
    
    // Code for the horizontal navigation buttons at the bottom. One button for each of 4 tabs
    var body: some View {
        NavigationStack {
            TabView(selection: $openTab) {
                CalendarPage()
                    .tabItem() {
                        Image(systemName: "calendar")
                    }
                    .tag(0)
                ToDoPage()
                    .tabItem() {
                        Image(systemName: "list.bullet")
                    }
                    .tag(1)
                TimerPage()
                    .tabItem() {
                        Image(systemName: "stopwatch")
                    }
                    .tag(2)
                StatsPage()
                    .tabItem() {
                        Image(systemName: "chart.pie")
                    }
                    .tag(3)
                
                // Also contains the header and other top items of the UI
            } .toolbar {
                if openTab == 0 {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink("Course List") {
                            CourseListPage().navigationTitle("All Courses")
                        }
                    }
                }
                /* This is temporary. I'm thinking something more like a modal popping up when the user presses the user icon. Entirely new page might be tedius.*/
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(role: .destructive, action: { viewModel.logOut() }) {
                            Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                        Button(action: { print("future functionality") }) {
                            Label("Future Functionality", systemImage: "globe")
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
    @State private var cancellables = Set<AnyCancellable>()
    @State private var selectedCourses: [Course] = []
    
    
    var body: some View {
        VStack(){
            TextField("Search Courses", text: $queryString)
                .padding(.horizontal)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: queryString) { newValue in
                    searchCourses()
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
            if courseIsSelected(course: course) {
                removeCourse(course: course)
            } else {
                addCourse(course: course)
            }
        }
        
    // Function that actually adds the course to internal structures
    func addCourse(course: Course) {
        NetworkManager.shared.addCourse(courseId: course.id) { success, error in
            if success {
                self.selectedCourses.append(course)
                print("Added Course: \(course.title) (\(course.subj) \(course.course_number))")
            } else if let error = error {
                print("Error adding course: \(error)")
            }
        }
    }
    
    // Function that actually removes the course from internal structures
    func removeCourse(course: Course) {
        NetworkManager.shared.removeCourse(courseId: course.id) { success, error in
            if success {
                self.selectedCourses.removeAll { $0.id == course.id }
                print("Removed Course: \(course.title) (\(course.subj) \(course.course_number))")
            } else if let error = error {
                print("Error removing course: \(error)")
            }
        }
    }
}

// View for the To-Do page
struct ToDoPage: View {
    struct TaskItem: Identifiable {
        let id = UUID()
        var name: String
        var isCompleted: Bool = false
    }
    
    @State private var tasks: [TaskItem] = []
    @State private var newTask: String = ""
    
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
    }
}

// Stats page that is used to gamify being a good student.
struct StatsPage: View {
    
    // Variables that are shown on the page
    @State private var semesterCompletion: Double = 100 * calculateSemesterPercentage()
    @State private var studyTimeInMinutes: Int = 334
    @State private var averageStudyTime: Int = 154

    var body: some View {
        VStack {
            Text("Statistics")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Divider()
            
            Text("Semester Completion")
                .font(.title)
                .padding()
            
            Text("\(semesterCompletion, specifier: "%.1f")%")
            
            ProgressView(value: semesterCompletion, total: 100)
                .padding()
            
            Text("Time Spent Studying")
                .font(.title)
                .padding()
            
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
            
            Text("\(averageStudyTime) minutes")
                .font(.headline)
                .padding()
        }
        .navigationTitle("Statistics")
    }
}

// Approximated semester % calculator
func calculateSemesterPercentage() -> Double {
    
    let percentage: Double
    
    // Get the current date
    let currentDate = Date()
    let calendar = Calendar.current

    // Semester Date Ranges Approximated
    let range1Start = Calendar.current.date(from: DateComponents(year: calendar.component(.year, from: currentDate), month: 8, day: 25))!
    let range1End = Calendar.current.date(from: DateComponents(year: calendar.component(.year, from: currentDate), month: 12, day: 15))!

    let range2Start = Calendar.current.date(from: DateComponents(year: calendar.component(.year, from: currentDate), month: 1, day: 15))!
    let range2End = Calendar.current.date(from: DateComponents(year: calendar.component(.year, from: currentDate), month: 5, day: 15))!

    if currentDate >= range1Start && currentDate <= range1End {
        let daysInRange = currentDate.daysBetweenDate(range1Start, andDate: range1End)
        let daysPassed = currentDate.daysBetweenDate(range1Start, andDate: currentDate)
        percentage = Double(daysPassed) / Double(daysInRange)
    } else if currentDate >= range2Start && currentDate <= range2End {
        let daysInRange = currentDate.daysBetweenDate(range2Start, andDate: range2End)
        let daysPassed = currentDate.daysBetweenDate(range2Start, andDate: currentDate)
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
        //ContentView(viewModel: AuthViewModel())
        
        // Or, if you want to specifically preview MainPageView with a logged-in state
        MainPageView(viewModel: AuthViewModel())
    }
}


