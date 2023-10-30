//
//  TimerViewModel.swift
//  UVM-StudyPal
//
//  Created by Evan Hinchliffe on 10/30/23.
//
import Foundation

class TimerViewModel: ObservableObject {
    enum TimerState {
        case work
        case shortBreak
        case longBreak
    }

    enum UserActionState {
        case notStarted
        case running
        case paused
    }

    private var timer: Timer?
    
    let workDuration = 25 * 60
    let shortBreakDuration = 5 * 60
    let longBreakDuration = 15 * 60
    
    private var completedPomodoros = 0
    
    @Published var remainingSeconds: Int = 25 * 60
    @Published var currentState: TimerState = .work
    @Published var userActionState: UserActionState = .notStarted

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
    
    func pauseTimer() {
        timer?.invalidate()
        userActionState = .paused
    }

    func resumeTimer() {
        startTimer()
    }
    
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
