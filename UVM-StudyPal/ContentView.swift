/**
 Main view file for UVM StudyPal. Defines the page flow for the app.
 Includes a preview struture for previewing in XCode.
 */

import SwiftUI

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
    var body: some View {
        Text("Course List")
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

