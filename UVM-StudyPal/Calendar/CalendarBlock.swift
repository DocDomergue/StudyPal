//
//  CalendarBlock.swift
//  UVM-StudyPal
//
//  Created by Zachary Hayes on 11/9/23.
//

import SwiftUI

struct CalendarBlock: View {
    @EnvironmentObject var manager: CalendarManager
    
    var desc: String
    var day: String
    var startTime: DateComponents
    var endTime: DateComponents
    var color: SwiftUI.Color
    
    // TODO: What's the true code for Sunday?
    let dayOptions = ["N", "M", "T", "W", "R", "F", "S"]
    
    var body: some View {
        VStack {
            Text(desc)
        }
        .frame(width: manager.getDayWidth(), height: getHeight())
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill()
                .foregroundColor(color)
        )
        .position(getPosition())
        
    }
    
    /**
     Calculate and return the length of this block in minutes
     */
    func getMinutes() -> Int {
        // Number of hours
        var totalHours = 0
        if let eHour = endTime.hour {
            if let sHour = startTime.hour {
                totalHours = eHour - sHour
            }
        }
        // Number of excess minutes
        var totalMin = 0
        if let eMin = endTime.minute {
            if let sMin = startTime.minute {
                totalMin = eMin - sMin
            }
        }
        // Calculate the minutes
        return (totalHours * 60) + totalMin
    }
    
    /**
     Calculate and retrieve the height of this block, based on start and end times.
     */
    func getHeight() -> CGFloat {
        // Convert the time to height on the screen
        return (CGFloat(getMinutes()) / 60) * manager.HOUR_HEIGHT
    }
    
    /**
     Calculate and retrieve the position that this block should be placed at. Based on start and end times,
     and day of week.
     */
    func getPosition() -> CGPoint {
        var x = 0
        var y = 0
        // Value of x is determined by day
        if let dayNum = dayOptions.firstIndex(of: day) {
            // 35? Why?
            // Magic number should be width of side times + padding
            x = 35 + (Int(manager.getDayWidth()) * (dayNum + 1))
        }
        
        // Value of y is determined by start and end time
        var startMinute = 0
        if let hours = startTime.hour {
            if let minutes = startTime.minute {
                startMinute = (hours * 60) + minutes
            }
        }
        let midMinute = startMinute + (getMinutes() / 2)
        // 54? Magic number again
        y = 54 + Int((CGFloat(midMinute) / 60) * manager.HOUR_HEIGHT)
        print(y)
        
        return CGPoint(x: x, y: y)
    }
    
}






