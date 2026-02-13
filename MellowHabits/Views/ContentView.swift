import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Übersicht", systemImage: "list.bullet")
                }
            
            HabitsListView()
                .tabItem {
                    Label("Gewohnheiten", systemImage: "checkmark.circle")
                }
            
            StatisticsView()
                .tabItem {
                    Label("Erfolge", systemImage: "trophy")
                }
        }
        .accentColor(.black)
    }
}
