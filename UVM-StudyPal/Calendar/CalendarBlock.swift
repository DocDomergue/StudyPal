//
//  CalendarBlock.swift
//  UVM-StudyPal
//
//  Created by Zachary Hayes on 11/9/23.
//

import SwiftUI

struct CourseBlock: View {
    @EnvironmentObject var manager: CalendarManager
    
    var item: CourseItem
    var additionalText: String = ""
    
    init(item: CourseItem) {
        self.item = item
        // Additional text for courses consists of info about the course
        additionalText += "\(item.subject) \(item.number)\n"
        additionalText += "\(item.instructor)\n"
        additionalText += "\(item.building) \(item.room)"
    }
    
    var body: some View {
        if !manager.isDayView ||
           (manager.isDayView &&
             item.getDayOfWeek() == manager.dayOfWeek) {
            BlockTemplate(
                color: manager.BLOCK_COLOR_COURSE,
                lightColor: manager.BLOCK_COLOR_COURSE_LIGHT,
                item: item,
                additionalText: additionalText
            )
        }
    }
}

struct StudyBlock: View {
    @EnvironmentObject var manager: CalendarManager
    
    var item: StudyItem
    var additionalText: String = ""
    
    init(item: StudyItem) {
        self.item = item
        // Additional text for study time consists of what to study for
        additionalText += "Study for \(item.course.name)"
    }
    
    var body: some View {
        if !manager.isDayView ||
           (manager.isDayView &&
             item.getDayOfWeek() == manager.dayOfWeek) {
            BlockTemplate(
                color: manager.BLOCK_COLOR_STUDY,
                lightColor: manager.BLOCK_COLOR_STUDY_LIGHT,
                item: item,
                additionalText: additionalText
            )
        }
    }
}

struct CustomBlock: View {
    @EnvironmentObject var manager: CalendarManager
    
    var item: CustomItem
    var additionalText: String = ""
    
    init(item: CustomItem) {
        self.item = item
        // Additional text for custom consists of the given description
        additionalText += item.description
    }
    
    var body: some View {
        if !manager.isDayView ||
           (manager.isDayView &&
             item.getDayOfWeek() == manager.dayOfWeek) {
            BlockTemplate(
                color: manager.BLOCK_COLOR_CUSTOM,
                lightColor: manager.BLOCK_COLOR_CUSTOM_LIGHT,
                item: item,
                additionalText: additionalText
            )
        }
    }
}


struct BlockTemplate: View {
    @EnvironmentObject var manager: CalendarManager
    
    var color: Color
    var lightColor: Color
    var item: CalendarItem
    var additionalText: String
    
    @State var titleHeight: CGFloat = 0
    @State var minutes: CGFloat = 0
    
    init(color: Color, lightColor: Color, item: CalendarItem, additionalText: String) {
        self.color = color
        self.lightColor = lightColor
        self.item = item
        self.additionalText = additionalText
        // variable declarations in onAppear
    }
    
    var body: some View {
        HStack { // Bogus HStack for the onAppear
            // Case where time is short, so only the title is displayed
            if Int(minutes) < manager.BLOCK_MIN_MINUTES * 2 {
                Text(item.name)
                    .font(.system(size: manager.BLOCK_FONT_SIZE))
                    .padding(.horizontal, 5)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(color)
                            .frame(width: manager.getDayWidth(), height: getHeight())
                    }
                    .frame(width: manager.getDayWidth(), height: getHeight())
                    .truncationMode(.tail)
                    .position(getPosition())
            }
            // Case where time is long, so an expanded description can be displayed
            else {
                VStack(spacing: 0) {
                    
                    // Title Rectangle
                    Text(item.name)
                        .font(.system(size: manager.BLOCK_FONT_SIZE))
                        .padding(.horizontal, 5)
                        .background {
                            Rectangle()
                                .foregroundColor(color)
                                .cornerRadius(5, corners: [.topLeft, .topRight])
                                .frame(width: manager.getDayWidth(), height: titleHeight)
                        }
                        .frame(width: manager.getDayWidth(), height: titleHeight)
                        .truncationMode(.tail)
                    
                    // Additional Text Rectangle
                    Text(additionalText)
                        .font(.system(size: manager.BLOCK_FONT_SIZE))
                        .padding(.horizontal, 5)
                        .background {
                            Rectangle()
                                .foregroundColor(lightColor)
                                .cornerRadius(5, corners: [.bottomLeft, .bottomRight])
                                .frame(width: manager.getDayWidth(), height: getHeight() - titleHeight)
                        }
                        .frame(width: manager.getDayWidth(), height: getHeight() - titleHeight)
                        .truncationMode(.tail)
                    
                }
                .position(getPosition())
            }
        }
        .onAppear {
            titleHeight = (CGFloat(manager.BLOCK_MIN_MINUTES) / 60) * manager.HOUR_HEIGHT
            minutes = self.item.getMinutes()
        }
    }
    
    /**
     Calculate and retrieve the height of this block, based on start and end times.
     */
    func getHeight() -> CGFloat {
        // In the case of a time duration that is too short to display text,
        // limit the time
        if Int(minutes) < manager.BLOCK_MIN_MINUTES {
            return (CGFloat(manager.BLOCK_MIN_MINUTES) / 60) * manager.HOUR_HEIGHT
        }
        // Convert the time to height on the screen
        return (CGFloat(minutes) / 60) * manager.HOUR_HEIGHT
    }
    
    /**
     Calculate and retrieve the position that this block should be placed at. Based on start and end times,
     and day of week.
     */
    func getPosition() -> CGPoint {
        // Value of x is determined by day
        var x = 0
        if manager.isDayView {
            x = Int(manager.getPositionOffset())
        }
        else {
            x = Int(manager.getPositionOffset()) + (Int(manager.getDayWidth()) * item.getDayOfWeek())
        }
        
        // Value of y is determined by start and end time
        var y = 0
        var startMinute: CGFloat = 0
        if let hours = item.startTime.hour {
            if let mins = item.startTime.minute {
                startMinute = CGFloat((hours * 60) + mins)
            }
        }
        // Blocks smaller than the minumum need to be calculated based
        // on the minimum size, not the true minutes.
        let mins: CGFloat = Int(minutes) >= manager.BLOCK_MIN_MINUTES ? minutes : CGFloat(manager.BLOCK_MIN_MINUTES)
        let midMinute = startMinute + CGFloat(mins / 2)
        // 5? Magic number again
        y = 5 + Int((midMinute / 60) * manager.HOUR_HEIGHT)
        
        return CGPoint(x: x, y: y)
    }
}

/*  The following extension and struct are used to round specific corners of a block.
    This code was found here:
    https://stackoverflow.com/questions/56760335/round-specific-corners-swiftui
 */
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct CalendarBlock_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            CourseBlock(item: CourseItem(
                name: "Mobile App Developement",
                subject: "CS",
                number: "3750",
                instructor: "Jason Hibbeler",
                building: "Lafayete",
                room: "L300",
                startTime: DateComponents(
                    year: 2023,
                    month: 11,
                    day: 28,
                    hour: 10,
                    minute: 5
                ),
                endTime: DateComponents(
                    year: 2023,
                    month: 11,
                    day: 28,
                    hour: 10,
                    minute: 40
                )
            ))
        }
        .environmentObject(CalendarManager())
    }
        
}
