import SwiftUI
import Charts

struct StatisticsView: View {
    @Environment(HabitStore.self) private var store
    
    private let mellowAccent = Color(red: 0.98, green: 0.82, blue: 0.25)
    private let cozyBg = Color(red: 0.96, green: 0.93, blue: 0.88)
    private let deepGold = Color(red: 0.75, green: 0.55, blue: 0.10)

    private var weeklyActivity: [ActivityData] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return (0...6).reversed().map { dayOffset in
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: today)!
            let dayName = date.formatted(.dateTime.weekday(.short))
            
            let count = store.habits.reduce(0) { total, habit in
                total + habit.punchDates.filter { calendar.isDate($0, inSameDayAs: date) }.count
            }
            return ActivityData(day: dayName, count: count)
        }
    }

    private var achievedHabits: [Habit] {
        store.habits.filter { $0.isCelebrated && $0.totalGoal == 10 }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                cozyBg.ignoresSafeArea()
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 25) {
                            activityChartCard
                            statsSummaryCard
                            
                            if achievedHabits.isEmpty {
                                emptyState
                            } else {
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("Meilensteine")
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .padding(.leading, 5)
                                    ForEach(achievedHabits) { habit in
                                        achievedRow(habit: habit)
                                    }
                                }
                            }
                            Spacer(minLength: 150)
                        }
                        .padding(.horizontal, 25)
                    }
                }
            }
        }
    }

    // --- Komponenten ---
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Deine Erfolge")
                .font(.system(size: 40, weight: .heavy, design: .rounded))
            Text("Dein Weg zur Meisterschaft").italic().foregroundColor(deepGold)
        }
        .padding(.horizontal, 25).padding(.top, 30).padding(.bottom, 20)
    }

    private var activityChartCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Wochenaktivität").font(.caption).bold().foregroundColor(.secondary)
            Chart {
                ForEach(weeklyActivity) { data in
                    BarMark(x: .value("Tag", data.day), y: .value("Stempel", data.count))
                        .foregroundStyle(data.count > 0 ? mellowAccent.gradient : Color.gray.opacity(0.1).gradient)
                        .cornerRadius(6)
                }
            }
            .frame(height: 150)
            .chartYAxis(.hidden)
        }
        .padding(20).background(Color.white).cornerRadius(24).shadow(color: .black.opacity(0.04), radius: 10)
    }

    private var statsSummaryCard: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Gesamte Stempel").font(.caption).bold().foregroundColor(.secondary)
                Text("\(store.habits.reduce(0) { $0 + $1.currentPunches })")
                    .font(.system(size: 32, weight: .heavy, design: .rounded)).foregroundColor(deepGold)
            }
            Spacer()
            Image(systemName: "trophy.fill").font(.title).foregroundColor(mellowAccent)
        }
        .padding(20).background(Color.white).cornerRadius(24)
    }

    private func achievedRow(habit: Habit) -> some View {
        HStack {
            Image(systemName: habit.currentPunches == habit.totalGoal ? "star.fill" : "medal.fill")
                .foregroundColor(deepGold)
            VStack(alignment: .leading) {
                Text(habit.title).font(.headline)
                Text("Fortschritt").font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            Text("\(habit.currentPunches)/\(habit.totalGoal)").bold().monospacedDigit()
        }
        .padding().background(Color.white).cornerRadius(20)
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "sparkles").font(.largeTitle).opacity(0.3)
            Text("Sammle mehr Stempel für Meilensteine.").font(.caption).foregroundColor(.secondary)
        }.padding(.top, 40)
    }
}

struct ActivityData: Identifiable {
    let id = UUID()
    let day: String
    let count: Int
}

#Preview {
    let store = HabitStore()
    store.clearAllData()
    store.addHabit(title: "Preview", time: "Abend", goal: 10)
    if let h = store.habits.first { for _ in 0..<8 { store.addPunch(to: h) } }
    return StatisticsView().environment(store)
}
