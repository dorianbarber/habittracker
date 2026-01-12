//
//  StopwatchViewModel.swift
//  habittracker
//
//  Created by Dorian Barber on 1/12/26.
//


import SwiftUI
import Combine

@MainActor
final class StopwatchViewModel: ObservableObject {
    @Published private(set) var elapsedSeconds: Int = 0
    @Published private(set) var isRunning: Bool = false

    private var lastTick: Date = .now
    private var tickingTask: Task<Void, Never>?

    func toggle() {
        isRunning ? stop() : start()
    }

    func reset() {
        elapsedSeconds = 0
        lastTick = .now
    }

    private func start() {
        guard !isRunning else { return }
        isRunning = true
        lastTick = .now
        tickingTask = Task { [weak self] in
            guard let self else { return }
            let clock = ContinuousClock()
            while !Task.isCancelled {
                try? await clock.sleep(for: .seconds(1))
                elapsedSeconds += Int(Date().timeIntervalSince(lastTick).rounded())
                lastTick = .now
            }
        }
    }

    private func stop() {
        guard isRunning else { return }
        isRunning = false
        tickingTask?.cancel()
        tickingTask = nil
    }
}
