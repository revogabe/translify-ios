//
//  MessageView.swift
//  Translify
//
//  Created by Daniel Gabriel on 21/09/23.
//

import SwiftUI

struct MessageView: View {
    @StateObject var viewModel: MessageViewModel

    var body: some View {
        VStack(spacing: 0) {
            chatSelection
            ScrollViewReader { scrollView in
                List(viewModel.messages) { message in
                    messageView(for: message)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .id(message.id)
                        .onChange(of: viewModel.messages) { newValue in
                        scrollToBottom(scrollView: scrollView)
                    }
                }
                    .background(Color(uiColor: .systemGroupedBackground))
                    .listStyle(.plain)
            }
            messageInputView
        }
            .navigationTitle(viewModel.chat?.topic ?? "New Chat")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
            viewModel.fetchData()
        }
    }

    func scrollToBottom(scrollView: ScrollViewProxy) {
        guard !viewModel.messages.isEmpty, let lastMessage = viewModel.messages.last else { return }

        withAnimation {
            scrollView.scrollTo(lastMessage.id)
        }
    }

    var chatSelection: some View {
        Group {
            if let model = viewModel.chat?.model.name {
                Text(model)
                    .padding(8)
                    .font(.caption)
                    .background(.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Picker(selection: $viewModel.selectedModel) {
                    ForEach(ChatModel.allCases, id: \.self) { model in
                        Text(model.name)
                    }
                } label: {
                    Text("")
                }
                    .padding()
                    .pickerStyle(.segmented)

            }
        }
    }

    func messageView(for message: AppMessage) -> some View {
        HStack {
            if (message.role == .user) {
                Spacer()
            }

            Text(message.text)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .foregroundStyle(message.role == .user ? .white : .white.opacity(0.8))
                .background(message.role == .user ? Color("ui-primary-hover") : .gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            if (message.role == .assistant) {
                Spacer()
            }
        }
    }

    var messageInputView: some View {
        HStack {
            TextField("Envie uma menssagem...", text: $viewModel.messageText)
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.leading)
                .padding(.vertical)
                .onSubmit {
                sendMessage()
            }

            Button {
                sendMessage()
            } label: {
                Label("Send", systemImage: "paperplane.fill")
                    .padding()
                    .background(Color("ui-primary"))
                    .foregroundStyle(Color.white)
                    .bold()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.trailing)
                    .padding(.leading, 4)
            }
        }
    }

    func sendMessage() {
        Task {
            do {
                try await viewModel.sendMessage()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    MessageView(viewModel: .init(chatId: ""))
}
