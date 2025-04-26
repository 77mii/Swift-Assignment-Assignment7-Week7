//
//  ContentView.swift
//  PulseCompanionWatch Watch App
//
//  Created by student on 10/04/25.
//








import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @StateObject private var viewModel = BreathingViewModel()
    @State private var scale: CGFloat = 1.0
    @State private var color: Color = .blue

    var body: some View {
        VStack {
            Image(systemName: "heart.fill")
                .resizable()
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .scaleEffect(scale)
                .onChange(of: viewModel.isRunning) { running in
                    if running {
                        startPulsing()
                    } else {
                        stopPulsing()
                    }
                }

            Text("\(Int(viewModel.sessionTime)) sec")

            Button(viewModel.isRunning ? "Stop" : "Start") {
                viewModel.toggleSession()
            }

            if let latest = viewModel.sessions.first {
                Text("Last: \(Int(latest.duration)) sec")
                    .font(.footnote)
            }
        }
        .onAppear {
            viewModel.onSessionFinished = { session in
                //print statements for debugging
//                print("session sending")
//                print("checking iphone is reachable\(WCSession.default.isReachable)")
//                print("session sent: \(session.start) - \(session.end)")

                SessionSyncManager.shared.sendSession(session)
            }

            if viewModel.isRunning {
                startPulsing()
            }
        }
    }

    // MARK: - Animation Controls
    func startPulsing() {
        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            scale = 1.4
            color = .purple
        }
    }

    func stopPulsing() {
        withAnimation(.easeInOut(duration: 0.3)) {
            scale = 1.0
            color = .blue
        }
    }
}

#Preview {
    ContentView()
}
