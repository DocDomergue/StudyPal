//
//  WeekPicker.swift
//  UVM-StudyPal
//
//  Created by Zachary Hayes on 11/9/23.
//

import SwiftUI

struct WeekPicker: View {
    @EnvironmentObject var manager: CalendarManager
    @State private var showPicker = false
    
    var body: some View {
        HStack {
            // Back a Week
            Button(action: {manager.weekDecrease()}) {
                Image(systemName: "chevron.left")
                    .frame(width: 50, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill()
                            .foregroundColor(Color(hue: 0.131, saturation: 0.982, brightness: 0.822))
                            .opacity(0.3)
                    )
            }
            
            // Week Display / Pick
            Button(action: {showPicker = true}) {
                Text(manager.describeWeek())
                // TODO: Better sizing
                    .frame(width: 200, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill()
                            .foregroundColor(Color(hue: 0.131, saturation: 0.982, brightness: 0.822))
                            .opacity(0.5)
                    )
            }
            .sheet(isPresented: $showPicker) {
                WeekPickerSheet()
            }
            
            // Forward a Week
            Button(action: {manager.weekIncrease()}) {
                Image(systemName: "chevron.right")
                    .frame(width: 50, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill()
                            .foregroundColor(Color(hue: 0.131, saturation: 0.982, brightness: 0.822))
                            .opacity(0.3)
                    )
            }
        }
    }
}

struct WeekPickerSheet: View {
    @EnvironmentObject var manager: CalendarManager
    @State var pickedWeek: Set<DateComponents> = []
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView() {
            // TODO: Provide a range to MultiDatePicker to limit to particular semester/year
            MultiDatePicker("Pick a Week", selection: $pickedWeek)
                .onChange(of: pickedWeek) { [pickedWeek] newDates in
                    let dif = newDates.subtracting(pickedWeek)
                    // If a new date was found, change the week
                    if let newDate = dif.first {
                        // Set the visible week to the week of the selected date
                        let week = manager.getWeek(of: newDate)
                        self.pickedWeek = week
                        manager.setWeek(week)
                    }
                    // Else, don't let it change
                    else {
                        self.pickedWeek = pickedWeek
                    }
                }
                .navigationTitle(manager.describeWeek())
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
        .onAppear() {
            self.pickedWeek = manager.visibleWeek
        }
    }
}

struct WeekPicker_Previews: PreviewProvider {
    static var previews: some View {
        WeekPicker()
            .environmentObject(CalendarManager())
    }
}

