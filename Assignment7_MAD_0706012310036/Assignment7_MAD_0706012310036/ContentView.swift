//
//  ContentView.swift
//  Assignment7_MAD_0706012310036
//
//  Created by student on 10/04/25.
//

import SwiftUI



import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BreathingViewModel()

    var body: some View {
        VStack {
            BreathingCircle(isRunning: $viewModel.isRunning)

            Text("Session Time: \(Int(viewModel.sessionTime)) sec")
            Button(action: viewModel.toggleSession) {
                Text(viewModel.isRunning ? "Stop" : "Start")
            }

            if !viewModel.sessions.isEmpty {
                List(viewModel.sessions) { session in
                    VStack(alignment: .leading) {
                        Text("Start: \(session.start.formatted(date: .numeric, time: .standard))")
                        Text("Duration: \(Int(session.duration)) sec")
                    }
                }
            }
        }
        .padding()
        .onAppear {
       
            _ = SessionSyncManager.shared
        }
    }
}

#Preview {
    ContentView()
}
