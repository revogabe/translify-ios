import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: AuthViewModel = AuthViewModel()
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Text("Logado")
    }
}

#Preview {
    MainView()
}
