/**
 Main view file for UVM StudyPal. Defines the page flow for the app.
 Includes a preview struture for previewing in XCode.
 */

import SwiftUI
import Combine

struct ContentView: View {
    @State var loggedIn: Bool = false
    var body: some View {
        /*
         This is temporary.
         It doesn't work with the preview and a navStack
         would probably be better anyway.
         */
        if !loggedIn {
            LoginPage(loggedIn: $loggedIn)
        }
        else {
            MainPageView(loggedIn: $loggedIn)
        }
    }
}

struct MainPageView: View {
    @Binding var loggedIn: Bool
    var body: some View {
        NavigationStack() {
            TabView() {
                CalendarPage()
                    .tabItem() {
                        Image(systemName: "calendar")
                    }
                ToDoPage()
                    .tabItem() {
                        Image(systemName: "list.bullet")
                    }
                TimerPage()
                    .tabItem() {
                        Image(systemName: "stopwatch")
                    }
                StatsPage()
                    .tabItem() {
                        Image(systemName: "chart.pie")
                    }
            } .toolbar {
                /* This is temporary. I'm thinking something more like a modal popping up when the user presses the user icon. Entirely new page might be
                    tedius.
                 */
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(role: .destructive, action: {loggedIn = false}) {
                            Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                        Button(action: {print("furute functionality")}) {
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



struct LoginPage: View {
    @Binding var loggedIn: Bool
    var body: some View {
        VStack() {
            Text("Log In Now")
            Button("Log In", action: {loggedIn = true})
        }
    }
}

struct CalendarPage: View {
    var body: some View {
        NavigationStack() {
            VStack() {
                Text("Calendar")
                NavigationLink("To Course List Page") {
                    CourseListPage().navigationTitle("All Courses")
                }
            }
        }
    }
}


struct CourseListPage: View {
    @State private var queryString: String = ""
    @State private var courses: [Course] = []
    @State private var cancellables = Set<AnyCancellable>()
    @State private var selectedCourses: [Course] = []


    var body: some View {
        VStack(){
            Text("Course List")
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

        APICall(query: queryString)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching courses: \(error)")
                }
            }, receiveValue: { courses in
                self.courses = courses
            })
            .store(in: &cancellables)
    }
    func courseIsSelected(course: Course) -> Bool {
           return selectedCourses.contains(where: { $0.id == course.id })
       }

       func toggleCourseSelection(course: Course) {
           if let index = selectedCourses.firstIndex(where: { $0.id == course.id }) {
               selectedCourses.remove(at: index)
               print("Removed Course: \(course.title) (\(course.subj) \(course.course_number))")
           } else {
               selectedCourses.append(course)
               print("Added Course: \(course.title) (\(course.subj) \(course.course_number))")
           }
       }

}


struct ToDoPage: View {
    var body: some View {
        Text("To-Do's")
    }
}

struct TimerPage: View {
    var body: some View {
        Text("Timer")
    }
}

struct StatsPage: View {
    var body: some View {
        Text("Statistics")
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //ContentView()
        MainPageView(loggedIn: .constant(true))
    }
}

