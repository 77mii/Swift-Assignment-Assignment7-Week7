////
////  SessionSyncManager.swift
////  Assignment7_MAD_0706012310036
////
////  Created by student on 10/04/25.
////



import Foundation
import SwiftUI
import WatchConnectivity

class SessionSyncManager: NSObject, WCSessionDelegate, ObservableObject {
    @Published private(set) var isActivated = false


    static let shared = SessionSyncManager()
    
    private override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

//Commented portions are for debugging :3
    func sendSession(_ session: BreathingSession) {
//        print("📤 Attempting to send session...")

        if !isActivated {
//            print("❗ WCSession not activated yet — delaying send.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.sendSession(session) // try again shortly
            }
            return
        }

        guard WCSession.default.isReachable else {
//            print("📡 Session not reachable — cannot send session.")
            return
        }

        let payload: [String: Any] = [
            "start": session.start.timeIntervalSince1970,
            "end": session.end.timeIntervalSince1970
        ]

//        print("✅ Sending session with payload: \(payload)")

        WCSession.default.sendMessage(payload, replyHandler: nil) { error in
            print("Failed to send session:", error.localizedDescription)
        }
    }



    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let startTimestamp = message["start"] as? TimeInterval,
              let endTimestamp = message["end"] as? TimeInterval else {
//            print("❌ Invalid message format received.")
            return
        }

        let start = Date(timeIntervalSince1970: startTimestamp)
        let end = Date(timeIntervalSince1970: endTimestamp)
        let breathingSession = BreathingSession(start: start, end: end)
        
//the  #if os(iOS)  #else  #endif makes it so that it only compiles whatever is inside only if the OS is an iOS. done so the compiler doesn't beat me up :V
        
        #if os(iOS)
//        print("📥 iPhone received session message: start=\(start), end=\(end)")
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .didReceiveSession, object: breathingSession)
        }
        #else
//        print("📭 Session received on watchOS — ignored.")
        #endif
    }


    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession did become inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession did deactivate")
        isActivated = false
        WCSession.default.activate()
    }

    #endif

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: (any Error)?) {
        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState.rawValue)")
            isActivated = true
        }
    }

}
