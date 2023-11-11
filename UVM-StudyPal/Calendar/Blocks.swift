//
//  Blocks.swift
//  UVM-StudyPal
//
//  Created by Zachary Hayes on 11/9/23.
//

import SwiftUI

struct Blocks: View {
    var body: some View {
        CalendarBlock(desc: "Test",
                      days: ["M", "W", "F"],
                      startTime: "18:00",
                      endTime: "19:00",
                      color: Color.blue)
    }
}
