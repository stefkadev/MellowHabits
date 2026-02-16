import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    private let mellowAccent = Color(red: 0.98, green: 0.82, blue: 0.25)
    private let deepGold = Color(red: 0.75, green: 0.55, blue: 0.10)
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                DashboardView()
                    .tag(0)
                
                HabitListView()
                    .tag(1)
                
                StatisticsView()
                    .tag(2)
                
                SettingsView()
                    .tag(3)
            }
            .onAppear {
                UITabBar.appearance().isHidden = true
            }
            
            // --- Neue Gelbe Custom Floating Tab Bar ---
            HStack {
                tabButton(icon: "list.bullet.rectangle", index: 0)
                Spacer()
                tabButton(icon: "checkmark.seal", index: 1)
                Spacer()
                tabButton(icon: "chart.pie", index: 2)
                Spacer()
                tabButton(icon: "gearshape", index: 3)
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(mellowAccent) // Jetzt ist die ganze Leiste gelb
                    .shadow(color: mellowAccent.opacity(0.4), radius: 15, x: 0, y: 8)
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 15) // Etwas mehr Platz nach unten
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private func tabButton(icon: String, index: Int) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = index
            }
        }) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .bold))
                // AKTIV: Weiß für maximalen Kontrast | INAKTIV: Dunkles Gold
                .foregroundColor(selectedTab == index ? .white : deepGold.opacity(0.6))
                .frame(width: 45, height: 45)
                .background(
                    Circle()
                        // Ein subtiler dunklerer Gelbton für den Auswahlkreis
                        .fill(selectedTab == index ? deepGold.opacity(0.2) : Color.clear)
                )
        }
    }
}

// MARK: - Preview (Pflicht)
#Preview {
    // Wir bauen hier direkt die Reset-Logik für eine saubere Vorschau ein
    let previewStore = HabitStore()
    previewStore.clearAllData()
    
    return ContentView()
        .environment(previewStore)
}
