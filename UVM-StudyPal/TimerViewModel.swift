//
//  TimerViewModel.swift
//  UVM-StudyPal
//
//  Created by Evan Hinchliffe on 10/30/23.
//
import Foundation


// Timer model had a lot of stuff going on so we seperated it out to not make content view even more cluttered than it is
class TimerViewModel: ObservableObject {
    
    // Enumerated states of the timer
    enum TimerState {
        case work
        case shortBreak
        case longBreak
    }

    // Enumerated states of the app's tracking of the timer
    enum UserActionState {
        case notStarted
        case running
        case paused
    }

    // A swift timer object to actually do the time keeping
    private var timer: Timer?
    
    // Variables to track and reference in the UI
    let workDuration = 25 * 60
    let shortBreakDuration = 5 * 60
    let longBreakDuration = 15 * 60
    
    private var completedPomodoros = 0
    
    // Variables used in the UI for display
    @Published var remainingSeconds: Int = 25 * 60
    @Published var currentState: TimerState = .work
    @Published var userActionState: UserActionState = .notStarted

    // Function called with the start timer button
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.remainingSeconds > 0 {
                self.remainingSeconds -= 1
            } else {
                self.timerFinished()
            }
        }
        userActionState = .running
    }
    
    // Function used to skip the timer ahead to being complete, mainly for demo purposes
    func advanceTimer() {
        self.timerFinished()
    }
    
    // Function for the pause button
    func pauseTimer() {
        timer?.invalidate()
        userActionState = .paused
    }

    // Function for the resume button
    func resumeTimer() {
        startTimer()
    }
    
    // Function for the reset button
    func resetTimer() {
        timer?.invalidate()
        switch currentState {
        case .work:
            remainingSeconds = workDuration
        case .shortBreak:
            remainingSeconds = shortBreakDuration
        case .longBreak:
            remainingSeconds = longBreakDuration
        }
        userActionState = .notStarted
    }
    
    // Internal function that handles the 4 step cycle of a Pomodoro method session.
    private func timerFinished() {
        switch currentState {
        case .work:
            completedPomodoros += 1
            if completedPomodoros == 4 {
                currentState = .longBreak
                completedPomodoros = 0
            } else {
                currentState = .shortBreak
            }
        default:
            currentState = .work
        }
        resetTimer()
    }
}
