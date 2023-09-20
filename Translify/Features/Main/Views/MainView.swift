import SwiftUI
import FirebaseAuth

struct MainView: View {
    @ObservedObject var viewModel: AuthViewModel = AuthViewModel()
    @EnvironmentObject var appState: AppState

    
    var body: some View {
        Text(appState.userEmail ?? "Logado")
        
        Button("Sair da conta") {
            viewModel.logout(appState: appState)
        }
    }
}

#Preview {
    MainView()
}
