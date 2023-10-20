//
//  ContentView.swift
//  UVM-StudyPal
//
//  Created by Kevin Encarnacao on 10/5/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
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
        ContentView()
    }
}

