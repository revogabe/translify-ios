//
//  AuthService.swift
//  Translify
//
//  Created by Daniel Gabriel on 20/09/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class AuthService {

    let db = Firestore.firestore()

    func checkUserExists(email: String) async throws -> Bool {
        let query = db.collection("users").whereField("email", isEqualTo: email)
        let countQuery = query.count
        let snapshot = try await countQuery.getAggregation(source: .server)

        print(snapshot.count)
        return Int(truncating: snapshot.count) > 0
    }

    func signIn(email: String, password: String) async throws -> AuthDataResult? {

        guard !password.isEmpty else { return nil }

        return try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func signUp(email: String, password: String) async throws -> AuthDataResult? {

        guard !password.isEmpty else { return nil }

        return try await Auth.auth().createUser(withEmail: email, password: password)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }
}
