import SwiftUI

struct CustomBackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            
            HStack(alignment: .center, spacing: 4) {
                Image(systemName: "arrow.left") // Ícone personalizado para voltar
                    .imageScale(.medium)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.gray)
                
                Text("Voltar")
                    .foregroundStyle(.gray)
            }
            .padding(8)
            .background(.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
        }
    }
}

#Preview {
    CustomBackButton()
}
