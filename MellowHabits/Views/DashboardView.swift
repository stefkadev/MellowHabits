import SwiftUI

struct DashboardView: View {
    @Environment(HabitStore.self) private var store
    @State private var showingAddSheet = false
    @State private var filterSelection: FilterType = .all
    
    // NEU: State für das ausgewählte Datum (0 = Di, ..., 6 = Mo/Heute)
    @State private var selectedDateIndex: Int = 6
    
    private let mellowAccent = Color(red: 0.98, green: 0.82, blue: 0.25)
    private let cozyBg = Color(red: 0.96, green: 0.93, blue: 0.88)
    private let deepGold = Color(red: 0.75, green: 0.55, blue: 0.10)

    enum FilterType: String, CaseIterable {
        case all = "Alle"
        case unfulfilled = "Offen"
        case fulfilled = "Erledigt"
    }

    var filteredHabits: [Habit] {
        // Hier filterst du später nach dem Datum: store.habits.filter { $0.date == selectedDate }
        switch filterSelection {
        case .all: return store.habits
        case .unfulfilled: return store.habits.filter { $0.currentPunches < $0.totalGoal }
        case .fulfilled: return store.habits.filter { $0.currentPunches >= $0.totalGoal }
        }
    }

    var body: some View {
        ZStack {
            cozyBg.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                headerSection.padding(.top, 15)
                
                // Kalender jetzt interaktiv
                calendarHorizontalBar.padding(.top, 25)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Merkliste")
                        .font(.system(size: 40, weight: .heavy, design: .rounded))
                        .foregroundColor(Color.black.opacity(0.8))
                    
                    HStack(spacing: 8) {
                        Image(systemName: "heart.fill").font(.system(size: 10))
                        Text(selectedDateIndex == 6 ? "Done is better than perfect!" : "Done is better than perfect!")
                    }
                    .font(.system(size: 16, weight: .semibold, design: .serif))
                    .italic()
                    .foregroundColor(deepGold)
                }
                .padding(.horizontal, 25).padding(.top, 30)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 18) {
                        if filteredHabits.isEmpty {
                            Text("Keine Aufgaben für diesen Tag")
                                .font(.serifStyle)
                                .foregroundColor(.secondary)
                                .padding(.top, 40)
                        } else {
                            ForEach(filteredHabits) { habit in
                                HabitRowView(habit: habit)
                                    .background(Color.white)
                                    .cornerRadius(24)
                                    .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
                            }
                        }
                    }
                    .padding(.horizontal, 25).padding(.top, 20).padding(.bottom, 150)
                }
            }
            
            floatingActionButton.zIndex(1)
        }
        .sheet(isPresented: $showingAddSheet) { AddHabitView() }
    }

    // --- KALENDER LOGIK ---
    private var calendarHorizontalBar: some View {
        HStack(spacing: 0) {
            let days = ["Di", "Mi", "Do", "Fr", "Sa", "So", "Mo"]
            let dates = ["10", "11", "12", "13", "14", "15", "16"]
            
            ForEach(0..<7) { index in
                let isSelected = (selectedDateIndex == index)
                let isToday = (index == 6)
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        selectedDateIndex = index
                    }
                }) {
                    VStack(spacing: 10) {
                        Text(days[index])
                            .font(.system(size: 13, weight: isSelected ? .bold : .medium, design: .rounded))
                            .foregroundColor(isSelected ? .black : .secondary.opacity(0.4))
                        
                        Text(dates[index])
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .frame(width: 44, height: 44)
                            .background(
                                ZStack {
                                    if isSelected {
                                        Circle()
                                            .fill(isToday ? mellowAccent : Color.white)
                                            .shadow(color: isToday ? mellowAccent.opacity(0.4) : Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
                                        
                                        if !isToday {
                                            Circle().stroke(mellowAccent, lineWidth: 2)
                                        }
                                    } else {
                                        Circle().fill(Color.white.opacity(0.4))
                                    }
                                }
                            )
                            .foregroundColor(isSelected ? (isToday ? .white : deepGold) : .black.opacity(0.6))
                    }
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 15)
    }
    
    // ... (restliche Subviews: headerSection, floatingActionButton)
    private var headerSection: some View {
        HStack {
            Menu {
                Picker("Filter", selection: $filterSelection) {
                    ForEach(FilterType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Text(filterSelection.rawValue)
                    Image(systemName: "chevron.down")
                }
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.black.opacity(0.7))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.white)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.05), radius: 2)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("STAND")
                    .font(.system(size: 10, weight: .black, design: .rounded))
                    .kerning(1.2)
                    .foregroundColor(.secondary.opacity(0.5))
                Text(selectedDateIndex == 6 ? "Heute" : "1\(selectedDateIndex). Feb")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(deepGold)
            }
        }
        .padding(.horizontal, 25)
    }

    private var floatingActionButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: { showingAddSheet = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 30, weight: .light))
                        .foregroundColor(.white)
                        .frame(width: 68, height: 68)
                        .background(
                            LinearGradient(colors: [mellowAccent, Color(red: 0.95, green: 0.75, blue: 0.20)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .clipShape(Circle())
                        .shadow(color: mellowAccent.opacity(0.5), radius: 15, x: 0, y: 8)
                }
                .padding(.trailing, 25)
                .padding(.bottom, 110)
            }
        }
    }

    private func ensureInitialElements() {
        if store.habits.isEmpty {
            store.addHabit(title: "Minecraft-Garten pflegen", time: "Vormittags", goal: 1)
            store.addHabit(title: "Looten und Leveln", time: "Nachmittags", goal: 1)
            store.addHabit(title: "Kohlenhydrate sammeln", time: "Abendbrot", goal: 1)
        }
    }
}

// Hilfs-Extension für sauberen Code
extension Font {
    static var serifStyle: Font {
        .system(size: 16, weight: .medium, design: .serif)
    }
}

#Preview {
    DashboardView().environment(HabitStore())
}
