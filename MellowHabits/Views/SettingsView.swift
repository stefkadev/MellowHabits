import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            Color("MellowYellow").ignoresSafeArea()
            
            VStack {
                Text("Optionen")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .padding(.top, 20)
                
                // Eine Liste eignet sich hervorragend für Einstellungen
                List {
                    Section(header: Text("Profil")) {
                        Text("Name: Stefka")
                        Text("Erinnerungen verwalten")
                    }
                    
                    Section(header: Text("App")) {
                        Text("Design: Mellow Mode")
                        Text("Version 1.0")
                    }
                }
                .scrollContentBackground(.hidden) // Macht die Liste transparent, damit Gelb durchscheint
            }
        }
    }
}

#Preview {
    SettingsView()
}
