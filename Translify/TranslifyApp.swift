//
//  TranslifyApp.swift
//  Translify
//
//  Created by Daniel Gabriel on 19/09/23.
//

import SwiftUI

@main
struct TranslifyApp: App {

    @ObservedObject var appState: AppState = AppState()

    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn {
                NavigationStack(path: $appState.navigationPath) {
                    MainView()
                        .environmentObject(appState)
                }
            } else {
                AuthView()
                    .environmentObject(appState)
            }
        }
    }
}
