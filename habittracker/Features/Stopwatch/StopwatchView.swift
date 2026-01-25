//
//  StopwatchView.swift
//  habittracker
//
//  Created by Dorian Barber on 1/12/26.
//


import SwiftUI

struct StopwatchView: View {
    @StateObject private var model = StopwatchViewModel()

    var body: some View {
        VStack {
            VStack {
                // Time display in hh:mm:ss
                Spacer()
                Text(formattedTime(model.elapsedSeconds))
                    .font(.system(size: 64, design: .rounded))
                    .monospacedDigit()
                Spacer()
            }

            VStack {
                HStack{
                    // Reset Button (left)
                    CircleActionButton(title: "Reset", color: .gray.opacity(0.15)) {
                        model.reset()
                    }
                    .accessibilityLabel("Reset timer")

                    Spacer()

                    // Start / Stop Button (right)
                    CircleActionButton(title: model.isRunning ? "Stop" : "Start",
                                       color: model.isRunning ? .red.opacity(0.2) : .green.opacity(0.2)) {
                        model.toggle()
                    }
                    .accessibilityLabel(model.isRunning ? "Stop timer" : "Start timer")
                }
                .padding(.horizontal, 20)

                Spacer()
                
                if model.elapsedSeconds > 0 {
                    SaveActivityButton(elapsedSeconds: model.elapsedSeconds)
                }
            }
            Spacer()
        }
        .padding()
    }

    private func formattedTime(_ seconds: Int) -> String {
        let hrs = seconds / 3600
        let mins = (seconds % 3600) / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d:%02d", hrs, mins, secs)
    }
}

#Preview {
    StopwatchView()
}
