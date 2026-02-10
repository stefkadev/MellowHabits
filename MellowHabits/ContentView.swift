import SwiftUI

/// Hauptansicht mit integrierter Tab-Navigation
struct ContentView: View {
    var body: some View {
        TabView {
            // Tab 1: Übersicht
            ZStack {
                Color("MellowYellow").ignoresSafeArea()
                VStack {
                    Text("Mellow Habits")
                        .font(.custom("Marker Felt", size: 34))
                        .padding()
                    PunchCardView(title: "Recipe Punch Card", currentPunches: 6, totalGoal: 10)
                }
            }
            .tabItem { Label("Übersicht", systemImage: "square.grid.2x2") }
            
            // Tab 2: Erfolge
            ZStack {
                Color("MellowYellow").ignoresSafeArea()
                Text("Statistiken").font(.headline)
            }
            .tabItem { Label("Erfolge", systemImage: "checkmark.seal") }
            
            // Tab 3: Optionen
            ZStack {
                Color("MellowYellow").ignoresSafeArea()
                Text("Einstellungen").font(.headline)
            }
            .tabItem { Label("Optionen", systemImage: "gearshape") }
        }
        .accentColor(.orange)
    }
}

/// Komponente zur Darstellung einer einzelnen Stempelkarte
struct PunchCardView: View {
    let title: String
    let currentPunches: Int
    let totalGoal: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.headline)
            HStack {
                ForEach(1...totalGoal, id: \.self) { index in
                    Circle()
                        .stroke(Color.black, lineWidth: 1)
                        .background(
                            Circle().fill(index <= currentPunches ? Color.orange.opacity(0.4) : Color.white)
                        )
                        .frame(width: 25, height: 25)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(10)
    }
}

#Preview {
    ContentView()
}
