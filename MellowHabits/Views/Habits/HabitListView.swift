import SwiftUI

struct HabitListView: View {
    @Environment(HabitStore.self) private var store
    @State private var showingAddSheet = false

    // Cozy Palette
    private let mellowAccent = Color(red: 0.98, green: 0.82, blue: 0.25)
    private let cozyBg = Color(red: 0.96, green: 0.93, blue: 0.88)
    private let deepGold = Color(red: 0.75, green: 0.55, blue: 0.10)

    private var punchCards: [Habit] {
        store.habits.filter { $0.totalGoal == 10 }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                cozyBg.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Punchcards")
                            .font(.system(size: 40, weight: .heavy, design: .rounded))
                            .foregroundColor(Color.black.opacity(0.8))
                        
                        HStack(spacing: 8) {
                            Image(systemName: "star.square.fill")
                                .font(.system(size: 14))
                            Text("Baue langfristige Gewohnheiten auf!")
                        }
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(deepGold)
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 30)
                    .padding(.bottom, 20)

                    ScrollView(.vertical, showsIndicators: false) {
                        if punchCards.isEmpty {
                            emptyState
                        } else {
                            VStack(spacing: 25) {
                                ForEach(punchCards) { habit in
                                    PunchCardView(habit: habit)
                                        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 8)
                                }
                            }
                            .padding(.horizontal, 25)
                            .padding(.top, 10)
                            // Genug Platz lassen, damit die letzte Karte nicht hinter dem Button "klebt"
                            .padding(.bottom, 180)
                        }
                    }
                }
                
                floatingAddButton.zIndex(1)
            }
            .sheet(isPresented: $showingAddSheet) {
                AddHabitView()
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Spacer().frame(height: 100)
            Image(systemName: "leaf.fill")
                .font(.system(size: 50))
                .foregroundColor(deepGold.opacity(0.2))
            Text("Noch keine aktiven Punchcards.")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var floatingAddButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: { showingAddSheet = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 30, weight: .bold)) // Etwas dicker für die Sichtbarkeit
                        .foregroundColor(.white)
                        .frame(width: 68, height: 68)
                        .background(
                            Circle()
                                .fill(mellowAccent)
                                // Der weiße Umrandungs-Ring:
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 4)
                                )
                        )
                        .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
                }
                .padding(.trailing, 25)
                .padding(.bottom, 110) // Deine bewährte Position
            }
        }
    }
}

// MARK: - Preview (Inklusive Reset & Marker)
#Preview {
    let previewStore = HabitStore()
    previewStore.clearAllData()
    previewStore.addHabit(title: "Code Projekt", time: "Täglich", goal: 10)
    previewStore.addHabit(title: "Sport machen", time: "3x Woche", goal: 10)
    
    return HabitListView()
        .environment(previewStore)
}
