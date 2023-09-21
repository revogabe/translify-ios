//
//  ProfileView.swift
//  Translify
//
//  Created by Daniel Gabriel on 21/09/23.
//

import SwiftUI

struct ProfileView: View {
    @State var apiKey: String = UserDefaults.standard.string(forKey: "openai_api_key") ?? ""
    
    var body: some View {
        List {
            Section("OpenAI API Key") {
                TextField("Enter key", text: $apiKey){
                    UserDefaults.standard.set(apiKey, forKey: "openai_api_key")
                }
                Link(destination: URL(string: "https://platform.openai.com/account/api-keys")!) {
                    HStack {
                        Text("Where can I get the OpenAI key?")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        Spacer()
                        Image(systemName: "link")
                            .foregroundStyle(Color("ui-primary"))
                            .font(.caption)
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
