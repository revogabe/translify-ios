//
//  ChatView.swift
//  Translify
//
//  Created by Daniel Gabriel on 21/09/23.
//

import SwiftUI

struct ChatView: View {
    @StateObject var viewModel = ChatViewModel()
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .loading, .none:
                Text("Loading chats...")
            case .noResults:
                Text("No chats")
            case .resultFound:
                List {
                    ForEach(viewModel.chats) { chat in
                        NavigationLink(value: chat.id) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(alignment: .center) {
                                    Text(chat.topic ?? "New chat")
                                        .font(.headline)
                                    Text(chat.model.name)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundStyle(chat.model.tintColor)
                                        .padding(6)
                                        .background(chat.model.tintColor.opacity(0.1))
                                        .clipShape(Capsule(style: .continuous))
                                }


                                Text(chat.lastMessageTimeAgo)
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                            .padding(4)
                            .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteChat(chat: chat)
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                        }
                    }
                }
            }
        }
            .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        do {
                            let chatID = try await viewModel.createChat(user: appState.currentUser?.uid)
                            appState.navigationPath.append(chatID)
                        } catch {
                            print(error)
                        }
                    }

                } label: {
                    HStack(alignment: .center, spacing: 4) {
                        Image(systemName: "plus")
                        Text("Nova conversa")
                    }
                }
            }
        }
            .navigationDestination(for: String.self, destination: { chatId in
            MessageView(viewModel: .init(chatId: chatId))
        })
            .onAppear {
            if viewModel.loadingState == .none {
                viewModel.fetchData(user: appState.currentUser?.uid)
            }

        }

    }
}

#Preview {
    ChatView()
}

