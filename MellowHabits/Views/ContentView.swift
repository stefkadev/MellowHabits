import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    private let mellowAccent = Color(red: 0.98, green: 0.82, blue: 0.25)
    
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
            
            // Custom Floating Tab Bar
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
            .padding(.vertical, 15)
            .background(
                Capsule()
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 5)
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 10) 
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private func tabButton(icon: String, index: Int) -> some View {
        Button(action: { selectedTab = index }) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(selectedTab == index ? mellowAccent : .gray.opacity(0.4))
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(selectedTab == index ? mellowAccent.opacity(0.1) : Color.clear)
                )
        }
    }
}

// MARK: - Preview (Pflicht-Check)
#Preview {
    ContentView()
        .environment(HabitStore())
}
