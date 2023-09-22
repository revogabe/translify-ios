import SwiftUI
import FirebaseAuth

struct MainView: View {
    @State private var selection = 0
    @StateObject var viewModel = ChatViewModel()

    var body: some View {
        TabView(selection: $selection) {
            Text("Tela 1")
                .tabItem {
                Label("Share", systemImage: "qrcode")
            }
                .tag(0)

            ChatView()
                .tabItem {
                Label("Chats", systemImage: "tray.fill")
                        
            }
                .tag(1)

            ProfileView()
                .tabItem {
                Label("Settings", systemImage: "gearshape")
            }
                .tag(2)
        }
            .accentColor(Color("ui-primary"))

    }
}

#Preview {
    MainView()
}
