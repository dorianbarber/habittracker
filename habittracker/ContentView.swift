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
        ZStack(alignment: .bottom) {
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
                .padding(.vertical)
            }

            // Bottom menu bar
            ZStack(alignment: .top) {
                HStack {
                    MenuButton(title: "Stopwatch", systemImage: "stopwatch", isSelected: selectedTab == .stopwatch) {
                        selectedTab = .stopwatch
                    }
                    
                    .glassEffectUnion(id: 1, namespace: screen)

                    MenuButton(title: "Logs", systemImage: "list.bullet", isSelected: selectedTab == .logbook) {
                        selectedTab = .logbook
                    }
                    .glassEffectUnion(id: 1, namespace: screen)

                    MenuButton(title: "Activities", systemImage: "person", isSelected: selectedTab == .activities) {
                        selectedTab = .activities
                    }
                    .glassEffectUnion(id: 1, namespace: screen)
                }
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 28))
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .padding(.bottom, 20)
                .shadow(color: Color.black.opacity(0.08), radius: 12, y: -2)
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .onAppear {
            print("ContentView modelContext: \(modelContext)")
        }
    }
}

#Preview {
    ContentView()
}
