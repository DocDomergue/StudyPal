//
//  WeekPicker.swift
//  UVM-StudyPal
//
//  Created by Zachary Hayes on 11/9/23.
//

import SwiftUI

struct WeekPicker: View {
    @State private var showPicker = false
    
    var body: some View {
        GeometryReader { viewGeometry in
            Button(action: {showPicker = true}) {
                Text("11/19 - 11/15 2023")
                    // TODO: Better sizing
                    .frame(width: 175, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill()
                            .foregroundColor(Color.gray)
                            .opacity(0.9)
                    )
            }
            // TODO: How do you position better?
            .position(x: viewGeometry.size.width - 100, y: viewGeometry.size.height - 50)
        }
        .sheet(isPresented: $showPicker, content: {
            WeekPickerSheet()
        })
    }
}

struct WeekPickerSheet: View {
    @Environment(\.dismiss) var dismiss
    /**
    dates is the set of dates picked in the multidate picker.
     */
    @State private var selectedDates: Set<DateComponents> = []
    @State private var date: Set<DateComponents> = []
    
    var body: some View {
        NavigationView() {
            // TODO: Provide a range to MultiDatePicker to limit to particular semester/
            ZStack {
                
                MultiDatePicker("Pick a Week", selection: $selectedDates)
                MultiDatePicker("Pick a Week", selection: $date)
                    .onChange(of: date) { newDate in
                        // Use this date to change selectedDates to that week
                        // Erase this date
                    }
                    .opacity(0.05)
                    
            }
            // TODO: Add title as same text displayed on button
            //.navigationTitle()
            .toolbar(content: {
                ToolbarItem {
                    Button {
                        dismiss()
                    } label: {
                        Label("Dismiss", systemImage: "xmark.circle.fill")
                    }
                }
            })
        }
        
    }
}

