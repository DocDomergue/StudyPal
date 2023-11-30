//
//  WeekView.swift
//  UVM-StudyPal
//
//  Created by Zachary Hayes on 11/9/23.
//

import SwiftUI

// Structure used to show the week view grid in the body of the parent view
struct WeekView: View {
    @EnvironmentObject var manager: CalendarManager
    
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            DayTimeGrid()
        }
        .onAppear {
            manager.setToWeekView()
        }
    }
    
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView()
            .environmentObject(CalendarManager())
    }
}
