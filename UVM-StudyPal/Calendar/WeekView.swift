//
//  WeekView.swift
//  UVM-StudyPal
//
//  Created by Zachary Hayes on 11/9/23.
//

import SwiftUI

struct WeekView: View {
    var body: some View {
        ZStack {
            ScrollView([.horizontal, .vertical]) {
                ZStack {
                    DayTimeGrid()
                    Blocks()
                }
            }
            WeekPicker()
        }
        .environmentObject(WVManager())
    }
}

class WVManager: ObservableObject {
    // Constants
    @Published var DAY_WIDTH: CGFloat = 115
    @Published var HOUR_HEIGHT: CGFloat = 50
    @Published var SIDE_PADDING: CGFloat = 100
    
    // ViewModel: handles the content of the calendar
    // TODO: @Published var visibleWeek:
    
}
