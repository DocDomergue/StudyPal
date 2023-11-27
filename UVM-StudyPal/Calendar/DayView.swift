//
//  DayView.swift
//  UVM-StudyPal
//
//  Created by Zachary Hayes on 11/22/23.
//

import SwiftUI

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
