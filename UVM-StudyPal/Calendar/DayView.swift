//
//  DayView.swift
//  UVM-StudyPal
//
//  Created by Zachary Hayes on 11/22/23.
//

import SwiftUI

// Structure used to show the day view in the body of the parent view
struct DayView: View {
    @EnvironmentObject var manager: CalendarManager
    
    var body: some View {
        ScrollView(.vertical) {
            DayTimeGrid()
        }
        .onAppear {
            manager.setToDayView()
        }
    }
        
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView()
            .environmentObject(CalendarManager())
    }
}
