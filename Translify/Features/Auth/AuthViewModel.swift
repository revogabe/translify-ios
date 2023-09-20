//
//  AuthViewModel.swift
//  Translify
//
//  Created by Daniel Gabriel on 20/09/23.
//

import Foundation

class AuthViewModel: ObservableObject {
    @Published var emailText: String = ""
    @Published var passwordText: String = ""

    @Published var isLoading = false

    let authService = AuthService()

    func register(appState: AppState) {
        isLoading = true

        Task {
            do {
                let result = try await authService.signUp(email: emailText, password: passwordText)
                await MainActor.run(body: {
                    guard let result = result else { return }
                    // update app state
                    appState.currentUser = result.user
                })

                return isLoading = false

            } catch {
                print(error)
                await MainActor.run {
                    isLoading = false
                }
            }

        }


    }

    func login(appState: AppState) {
        isLoading = true

        Task {
            do {
                let result = try await authService.signIn(email: emailText, password: passwordText)
                await MainActor.run(body: {
                    guard let result = result else { return }
                    // update app state
                    appState.currentUser = result.user
                })
                return isLoading = false
            } catch {
                print(error)
                await MainActor.run {
                    isLoading = false
                }
            }
        }
    }

    func logout (appState: AppState) {
        if appState.isLoggedIn {
            Task {
                do {
                    try authService.signOut()
                    appState.currentUser = nil
                } catch {
                    print("Deu erro ao sair")
                }
            }
        }
    }
}
