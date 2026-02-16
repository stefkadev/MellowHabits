import SwiftUI

struct StatisticsView: View {
    @Environment(HabitStore.self) private var store
    
    // Cozy Palette
    private let mellowAccent = Color(red: 0.98, green: 0.82, blue: 0.25)
    private let cozyBg = Color(red: 0.96, green: 0.93, blue: 0.88)
    private let deepGold = Color(red: 0.75, green: 0.55, blue: 0.10)

    // Logik: Punchcards, die zu mindestens 80% (8 von 10) gefüllt sind
    private var achievedHabits: [Habit] {
        store.habits.filter {
            let progress = Double($0.currentPunches) / Double($0.totalGoal)
            return progress >= 0.8 && $0.totalGoal == 10
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                cozyBg.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Deine Erfolge")
                            .font(.system(size: 40, weight: .heavy, design: .rounded))
                            .foregroundColor(Color.black.opacity(0.8))
                        
                        Text("Feiere Erfolge mit über 80% Fortschritt!")
                            .font(.system(size: 16, weight: .semibold, design: .serif))
                            .italic()
                            .foregroundColor(deepGold)
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 30)
                    .padding(.bottom, 20)

                    ScrollView(.vertical, showsIndicators: false) {
                        if achievedHabits.isEmpty {
                            emptyState
                        } else {
                            VStack(spacing: 20) {
                                // Statistik-Zusammenfassung Karte
                                statsSummaryCard
                                
                                ForEach(achievedHabits) { habit in
                                    achievedRow(habit: habit)
                                }
                            }
                            .padding(.horizontal, 25)
                            .padding(.top, 10)
                            .padding(.bottom, 160)
                        }
                    }
                }
            }
        }
    }

    // --- Komponenten ---

    private var statsSummaryCard: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Gesamte Stempel")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.secondary)
                Text("\(store.habits.reduce(0) { $0 + $1.currentPunches })")
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundColor(deepGold)
            }
            Spacer()
            Image(systemName: "trophy.circle.fill")
                .font(.system(size: 45))
                .foregroundColor(mellowAccent)
        }
        .padding(25)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
    }

    private func achievedRow(habit: Habit) -> some View {
        HStack(spacing: 15) {
            Circle()
                .fill(mellowAccent.opacity(0.2))
                .frame(width: 45, height: 45)
                .overlay(
                    Image(systemName: habit.currentPunches == habit.totalGoal ? "star.fill" : "pennant.stop.fill")
                        .foregroundColor(deepGold)
                        .font(.system(size: 18))
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(habit.title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                Text(habit.currentPunches == habit.totalGoal ? "Vollständig abgeschlossen!" : "Fast geschafft")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(habit.currentPunches)/\(habit.totalGoal)")
                .font(.system(.subheadline, design: .monospaced))
                .fontWeight(.bold)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(deepGold.opacity(0.1))
                .cornerRadius(10)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 100)
            Image(systemName: "trophy")
                .font(.system(size: 60))
                .foregroundColor(deepGold.opacity(0.2))
            Text("Noch keine Erfolge sichtbar.\nSammle mindestens 8 Stempel auf einer Karte!")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview (Pflicht)
#Preview {
    let previewStore = HabitStore()
    previewStore.addHabit(title: "Minecraft Garten", time: "Abends", goal: 10)

    if let first = previewStore.habits.first {
        for _ in 0..<8 { previewStore.addPunch(to: first) }
    }
    
    return StatisticsView()
        .environment(previewStore)
}
