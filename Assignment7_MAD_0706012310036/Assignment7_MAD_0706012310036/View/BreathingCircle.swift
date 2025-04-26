//
//  BreathingCircle.swift
//  Assignment7_MAD_0706012310036
//
//  Created by student on 10/04/25.
//
import SwiftUI

import SwiftUI

struct BreathingCircle: View {
    @Binding var isRunning: Bool
    @State private var scale: CGFloat = 1.0
    @State private var color: Color = .blue
    @State private var animate = false

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 150, height: 150)
            .scaleEffect(scale)
            .onAppear {
                if isRunning { startAnimation() }
            }
            .onChange(of: isRunning) { newValue in
                if newValue {
                    startAnimation()
                } else {
                    stopAnimation()
                }
            }
    }

    private func startAnimation() {
        animate = true
        withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
            scale = 1.5
            color = .purple
        }
    }

    private func stopAnimation() {
        animate = false
        withAnimation(.easeInOut(duration: 0.3)) {
            scale = 1.0
            color = .blue
        }
    }
}
