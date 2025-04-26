//
//  ContentView.swift
//  PulseCompanionMac
//
//  Created by student on 10/04/25.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BreathingViewModel()

    var body: some View {
        VStack(spacing: 20) {
            BreathingCircle(isRunning: $viewModel.isRunning)

            Text("Session Time: \(Int(viewModel.sessionTime)) sec")

            Button(viewModel.isRunning ? "Stop" : "Start") {
                viewModel.toggleSession()
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
        .frame(width: 400, height: 600)
    }
}


#Preview {
    ContentView()
        .frame(width: 400, height: 600)
}

