import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "list.bullet.rectangle.fill" : "list.bullet.rectangle")
                }
                .tag(0)
            
            HabitListView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "checkmark.seal.fill" : "checkmark.seal")
                }
                .tag(1)
            
            StatisticsView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "chart.pie.fill" : "chart.pie")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "gearshape.fill" : "gearshape")
                }
                .tag(3)
        }
        .accentColor(.black) // Aktives Icon ist schwarz
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white // Weiße Leiste wie im Screenshot
            
            // Verhindert das Verschwinden beim Scrollen
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    ContentView()
        .environment(HabitStore())
}
