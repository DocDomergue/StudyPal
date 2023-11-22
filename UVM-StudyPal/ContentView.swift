/**
 Main view file for UVM StudyPal. Defines the page flow for the app.
 Includes a preview struture for previewing in XCode.
 */

import SwiftUI
import Combine

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

struct MainPageView: View {
    @State var openTab = 0
    @ObservedObject var viewModel: AuthViewModel
    
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
            } .toolbar {
                if openTab == 0 {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink("To Course List Page") {
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

struct CalendarPageView: View {
    var username: String
    
    var body: some View {
        // Your CalendarPage content here
        Text("Welcome, \(username)! This is your calendar.")
    }
}


struct CalendarPage: View {
    var body: some View {
        WeekView()
    }
}


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
    
    func courseIsSelected(course: Course) -> Bool {
        return selectedCourses.contains(where: { $0.id == course.id })
    }
    
    func toggleCourseSelection(course: Course) {
            if courseIsSelected(course: course) {
                removeCourse(course: course)
            } else {
                addCourse(course: course)
            }
        }

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
                                    .foregroundColor(task.isCompleted ? .blue : .gray)
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
    
    func addTaskOnCommit() {
        addTask()
    }
    
    func addTask() {
        if !newTask.isEmpty {
            tasks.append(TaskItem(name: newTask))
            newTask = ""
        }
    }
    
    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
    
    func toggleTaskCompletion(_ task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
}

struct TimerPage: View {
    @StateObject var viewModel = TimerViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.currentState == .work ? "Work" : (viewModel.currentState == .shortBreak ? "Short Break" : "Long Break"))
                .font(.largeTitle)
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 15)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                
                Circle()
                    .trim(from: 0, to: CGFloat(1.0 - Double(viewModel.remainingSeconds) / Double(viewModel.currentState == .work ? viewModel.workDuration : (viewModel.currentState == .shortBreak ? viewModel.shortBreakDuration : viewModel.longBreakDuration))))
                    .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round))
                    .rotationEffect(Angle(degrees: -90))
                    .foregroundColor(.blue)
                
                Text("\(viewModel.remainingSeconds / 60):\(String(format: "%02d", viewModel.remainingSeconds % 60))")
                    .font(.largeTitle)
            }
            .frame(width: 200, height: 200)
            
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



struct StatsPage: View {
    @State private var semesterCompletion: Double = 64.5
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
            
            Spacer()
        }
        .navigationTitle("Statistics")
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // Previewing ContentView
        ContentView(viewModel: AuthViewModel())
        
        // Or, if you want to specifically preview MainPageView with a logged-in state
        //        MainPageVieehinchw(viewModel: AuthViewModel())
    }
}


