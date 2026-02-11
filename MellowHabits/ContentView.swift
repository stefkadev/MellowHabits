import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Übersicht", systemImage: "house")
                }
            
            StatisticsView()
                .tabItem {
                    Label("Erfolge", systemImage: "chart.bar")
                }
            
            SettingsView()
                .tabItem {
                    Label("Optionen", systemImage: "gearshape")
                }
        }
        .accentColor(.black)
    }
}

#Preview {
    ContentView()
}
