//
//  RegisterView.swift
//  Translify
//
//  Created by Daniel Gabriel on 20/09/23.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel: AuthViewModel = AuthViewModel()
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Spacer()

            VStack(alignment: .center, spacing: 6) {
                Image(systemName: "lasso.badge.sparkles")
                    .foregroundColor(Color("ui-primary"))
                    .font(.system(size: 64))

                Text("Translify")
                    .font(.system(size: 42))
                    .foregroundStyle(.foreground)
                    .fontWeight(.bold)


            }
                .padding()
                .padding(.bottom, 40)


            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.gray.opacity(0.5))
                    .frame(width: 20, height: 20)

                TextField("Email", text: $viewModel.emailText)
                    .padding(.leading, 8)
                    .textCase(nil)
                    .keyboardType(.emailAddress)
                    .accessibility(label: Text("Email"))
                    .accessibility(hint: Text("Digite seu email"))
            }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)

            HStack {
                Image(systemName: "lock")
                    .foregroundColor(.gray.opacity(0.5))
                    .frame(width: 20, height: 20)

                SecureField("Senha", text: $viewModel.passwordText)
                    .padding(.leading, 8)
                    .accessibility(label: Text("Senha"))
                    .accessibility(hint: Text("Digite sua senha"))
            }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            Spacer()

            if viewModel.isLoading {
                ProgressView()
            } else {
                
                Button(action: {
                    viewModel.register(appState: appState)
                }) {
                    Text("Criar conta")
                        .padding()
                        .fontWeight(.bold)
                        .accessibility(label: Text("Botão de entrar com apple"))
                        .frame(maxWidth: .infinity)
                        .background(Color("ui-primary"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .contentShape(Rectangle())
                
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    
                    Button(action: {
                        viewModel.register(appState: appState)
                    }) {
                        Text("Criar com Apple ID")
                            .padding()
                            .fontWeight(.bold)
                            .accessibility(label: Text("Botão de entrar com apple"))
                            .frame(maxWidth: .infinity)
                            .background(Color("ui-secondary"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .contentShape(Rectangle())
                    
                }
            }

        }
            .padding()
            .padding()
    }
}

#Preview {
    RegisterView()
}
