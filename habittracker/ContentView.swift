//
//  ContentView.swift
//  habittracker
//
//  Created by Dorian Barber on 1/7/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    enum Tab { case stopwatch, logbook, activities}
    @Namespace var screen
    @State private var selectedTab: Tab = .stopwatch
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 0) {
            // Main content area
            Group {
                switch selectedTab {
                case .stopwatch:
                    StopwatchView()
                case .logbook:
                    LogbookView()
                case .activities:
                    ActivitiesView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()

            // Bottom menu bar
            Divider()
            GlassEffectContainer {
                HStack {
                    MenuButton(title: "Stopwatch", systemImage: "stopwatch", isSelected: selectedTab == .stopwatch) {
                        selectedTab = .stopwatch
                    }
                    .glassEffect()
                    .glassEffectUnion(id: 1, namespace: screen)

                    MenuButton(title: "Logs", systemImage: "list.bullet", isSelected: selectedTab == .logbook) {
                        selectedTab = .logbook
                    }
                    .glassEffect()
                    .glassEffectUnion(id: 1, namespace: screen)
                    
                    MenuButton(title: "Activities", systemImage: "person", isSelected: selectedTab == .activities) {
                        selectedTab = .activities
                    }
                    .glassEffect()
                    .glassEffectUnion(id: 1, namespace: screen)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
        }
        .onAppear {
            print("ContentView modelContext: \(modelContext)")
        }
    }
}

#Preview {
    ContentView()
}
