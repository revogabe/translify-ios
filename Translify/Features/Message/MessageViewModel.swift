//
//  MessageViewModel.swift
//  Translify
//
//  Created by Daniel Gabriel on 21/09/23.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore
import OpenAI

class MessageViewModel: ObservableObject {
    @Published var chat: AppChat?
    @Published var messages: [AppMessage] = []
    @Published var messageText: String = ""
    @Published var selectedModel: ChatModel = .gpt3_5_turbo

    @AppStorage("openai_api_key") var apiKey = ""

    let chatId: String
    let db = Firestore.firestore()

    init(chatId: String) {
        self.chatId = chatId
    }

    func fetchData() {
        db.collection("chats").document(chatId).getDocument(as: AppChat.self) { result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.chat = success
                }
            case .failure(let failure):
                print(failure)
            }
        }

        db.collection("chats").document(chatId).collection("messages").getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents, !documents.isEmpty else { return }

            self.messages = documents.compactMap({ snapshot -> AppMessage? in
                do {
                    var message = try snapshot.data(as: AppMessage.self)
                    message.id = snapshot.documentID
                    return message
                } catch {
                    return nil
                }
            })

            self.messages = self.messages.reversed()
        }
    }


    func sendMessage() async throws {
        var newMessage = AppMessage(id: UUID().uuidString, text: messageText, role: .user)

        do {
            let documentRef = try storeMessage(message: newMessage)
            newMessage.id = documentRef.documentID
        } catch {
            print(error)
        }

        if messages.isEmpty {
            setupNewChat()
        }

        await MainActor.run { [newMessage] in
            messages.append(newMessage)
            messageText = ""
        }

        if let chatId = chat?.id {
            try await db.collection("chats").document(chatId).updateData(["topic": newMessage.text])
        }

        try await generateResponse(for: newMessage)

    }

    private func storeMessage(message: AppMessage) throws -> DocumentReference {
        return try db.collection("chats").document(chatId).collection("messages").addDocument(from: message)
    }

    private func setupNewChat() {
        db.collection("chats").document(chatId).updateData(["model": selectedModel.rawValue])
        DispatchQueue.main.async { [weak self] in
            self?.chat?.model = self?.selectedModel ?? .gpt3_5_turbo
        }
    }

    private func generateResponse(for message: AppMessage) async throws {
        let openAI = OpenAI(apiToken: apiKey)
//        let queryMessages = messages.map { appMessage in
//            Chat(role: appMessage.role, content: appMessage.text)
//        }
        let query = ChatQuery(model: chat?.model.model ?? .gpt3_5Turbo, messages: [
            Chat(role: .system, content: "Agora você é um auxiliar e professor de idiomas, sua função é enterder que lingua estou falando e corrigir minha gramatica e me explique oque eu errei, e depois me faça uma pergunta nova! Exemplo: Usuário: I'm happining, ChatGPT: Voce errou, o jeito certo de falar é I'm happy, (Explição...), I'm glad you're happy, what are you going to do today? / 'Me explique em português oque eu errei!'"), Chat(role: message.role, content: message.text)])
        for try await result in openAI.chatsStream(query: query) {
            guard let newText = result.choices.first?.delta.content else { continue }
            await MainActor.run {
                if let lastMessage = messages.last, lastMessage.role != .user {
                    messages[messages.count - 1].text += newText
                } else {
                    let newMessage = AppMessage(id: result.id, text: newText, role: .assistant)
                    messages.append(newMessage)
                }
            }
        }

        if let lastMessage = messages.last {
            _ = try storeMessage(message: lastMessage)
        }
    }
}


struct AppMessage: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var text: String
    let role: Chat.Role
    var createdAt: FirestoreDate = FirestoreDate()
}
