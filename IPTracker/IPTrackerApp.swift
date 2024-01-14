//
//  IPTrackerApp.swift
//  IPTracker
//
//  Created by Dmitry Fedorov on 13.01.2024.
//

import SwiftUI
import Combine

@main
struct IPTrackerApp: App {
    private let viewModel = MenuSceneViewModel()
    var body: some Scene {
        MenuScene(viewModel: viewModel)
    }
}

struct MenuScene: Scene {
    @ObservedObject fileprivate var viewModel: MenuSceneViewModel
    
    fileprivate init(viewModel: MenuSceneViewModel) {
        self.viewModel = viewModel
        viewModel.startFetching()
    }
    
    var body: some Scene {
        MenuBarExtra(
            content: {
                MenuSceneContent(lastUpdate: viewModel.lastUpdate)
            }, label: {
                Text(viewModel.ipAddress)
            }
        )
    }
}

struct MenuSceneContent: View {
    var lastUpdate: String
    
    var body: some View {
        VStack {
            Text(lastUpdate)
            Divider()
            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                Text("quit")
            }
        }
    }
}
