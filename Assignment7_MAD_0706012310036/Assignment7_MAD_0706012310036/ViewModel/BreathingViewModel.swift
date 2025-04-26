//
//  BreathingViewModel.swift
//  Assignment7_MAD_0706012310036
//
//  Created by student on 10/04/25.
//


import Foundation
import SwiftUI
import Combine

class BreathingViewModel: ObservableObject {
    @Published var isRunning = false
    @Published var sessionTime: TimeInterval = 0
    @Published var sessions: [BreathingSession] = []

    var onSessionFinished: ((BreathingSession) -> Void)? = nil
    private var timer: Timer?
    private var startTime: Date?

    init() {
        #if os(iOS)
        NotificationCenter.default.addObserver(
            forName: .didReceiveSession,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let session = notification.object as? BreathingSession {
                self?.sessions.insert(session, at: 0)
            }
        }
        #endif
    }



    func startSession() {
        isRunning = true
        startTime = Date()
        sessionTime = 0

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.sessionTime += 1
        }
    }


    func stopSession() {
        guard isRunning, let start = startTime else { return }

        timer?.invalidate()
        isRunning = false

        let end = Date()
        let session = BreathingSession(start: start, end: end)
        sessions.insert(session, at: 0)

     
        onSessionFinished?(session)
    }


    func toggleSession() {
        isRunning ? stopSession() : startSession()
    }
}
