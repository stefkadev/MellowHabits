import SwiftUI
import Charts

struct StatisticsView: View {
    @Environment(HabitStore.self) private var store
    
    // Cozy Palette
    private let mellowAccent = Color(red: 0.98, green: 0.82, blue: 0.25)
    private let cozyBg = Color(red: 0.96, green: 0.93, blue: 0.88)
    private let deepGold = Color(red: 0.75, green: 0.55, blue: 0.10)

    // Berechnet die Stempel pro Tag für die letzten 7 Tage
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

    private var weeklyStampsCount: Int {
        weeklyActivity.reduce(0) { $0 + $1.count }
    }
    
    // 80% Logik für die Hausarbeit
    private var consistencyRate: Double {
        let daysWithActivity = weeklyActivity.filter { $0.count > 0 }.count
        return (Double(daysWithActivity) / 7.0) * 100
    }

    var body: some View {
        NavigationStack {
            ZStack {
                cozyBg.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 30) {
                            
                            // 1. Aktivitäts-Diagramm
                            activityChartCard
                            
                            // 2. Deine Stempel Sektion
                            VStack(alignment: .leading, spacing: 12) {
                                Text("DEINE STEMPEL")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundColor(.black.opacity(0.6)) // Kontrast gefixt
                                    .padding(.leading, 5)
                                
                                HStack(spacing: 15) {
                                    statsSmallCard(title: "DIESE WOCHE", count: weeklyStampsCount, icon: "calendar")
                                    statsSmallCard(title: "GESAMT", count: store.habits.reduce(0) { $0 + $1.currentPunches }, icon: "trophy.fill")
                                }
                            }
                            
                            // 3. 80% Beständigkeits-Check
                            VStack(alignment: .leading, spacing: 12) {
                                Text("DEIN FOKUS")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundColor(.black.opacity(0.6)) // Kontrast gefixt
                                    .padding(.leading, 5)
                                
                                consistencyCard
                            }
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 25)
                    }
                }
            }
        }
    }

    // --- Komponenten (innerhalb der Struct, außerhalb vom body) ---

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Deine Erfolge")
                .font(.system(size: 40, weight: .heavy, design: .rounded))
                .foregroundColor(.black.opacity(0.8))
            Text("Deine Beständigkeit im Überblick")
                .font(.system(size: 16, weight: .medium, design: .serif))
                .italic()
                .foregroundColor(deepGold)
        }
        .padding(.horizontal, 25).padding(.top, 30).padding(.bottom, 20)
    }

    private var activityChartCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("TREND DER LETZTEN 7 TAGE")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(.black.opacity(0.6))
            
            Chart {
                ForEach(weeklyActivity) { data in
                    BarMark(
                        x: .value("Tag", data.day),
                        y: .value("Stempel", data.count)
                    )
                    .foregroundStyle(data.count > 0 ? mellowAccent.gradient : Color.gray.opacity(0.15).gradient)
                    .cornerRadius(8)
                }
            }
            .frame(height: 180)
            .chartYAxis(.hidden)
            .chartXAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.black.opacity(0.6)) // Wochentage besser sichtbar
                }
            }
        }
        .padding(22).background(Color.white).cornerRadius(28).shadow(color: .black.opacity(0.04), radius: 15)
    }

    private func statsSmallCard(title: String, count: Int, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon).foregroundColor(deepGold)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(count)")
                    .font(.system(size: 28, weight: .heavy, design: .rounded))
                    .foregroundColor(.black.opacity(0.8)) // Deutlicher Kontrast
                Text(title)
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(.black.opacity(0.6)) // Deutlicher Kontrast
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18).background(Color.white).cornerRadius(22).shadow(color: .black.opacity(0.03), radius: 8)
    }
    
    private var consistencyCard: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.1), lineWidth: 8)
                Circle()
                    .trim(from: 0, to: CGFloat(min(consistencyRate / 80.0, 1.0)))
                    .stroke(deepGold, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(consistencyRate))%")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.black.opacity(0.8))
            }
            .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(consistencyRate >= 80 ? "Perfekte Balance!" : "Auf dem Weg")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.black.opacity(0.8))
                Text("Dein Ziel: 80% Beständigkeit")
                    .font(.system(size: 13, design: .serif)).italic()
                    .foregroundColor(.black.opacity(0.6))
            }
            Spacer()
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(22)
        .shadow(color: .black.opacity(0.03), radius: 8)
    }
}

// MARK: - Datenstruktur & Preview
struct ActivityData: Identifiable {
    let id = UUID(); let day: String; let count: Int
}

#Preview {
    let store = HabitStore()
    store.clearAllData()
    let h = Habit(title: "Check", time: "Morgens", totalGoal: 10)
    store.habits.append(h)
    // Generiert künstliche Daten für die Preview
    for i in 0...5 {
        if let d = Calendar.current.date(byAdding: .day, value: -i, to: Date()) {
            h.punchDates.append(d)
        }
    }
    return StatisticsView().environment(store)
}
