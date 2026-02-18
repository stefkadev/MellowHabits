import SwiftUI

struct CalendarDay: Identifiable {
    let id = UUID()
    let day: String
    let date: String
    let fullDate: Date
}

struct DashboardView: View {
    @Environment(HabitStore.self) private var store
    @State private var showingAddSheet = false
    @State private var filterSelection: FilterType = .all
    @State private var selectedDateIndex: Int = 6
    
    private let mellowAccent = Color(red: 0.98, green: 0.82, blue: 0.25)
    private let cozyBg = Color(red: 0.96, green: 0.93, blue: 0.88)
    private let deepGold = Color(red: 0.75, green: 0.55, blue: 0.10)

    enum FilterType: String, CaseIterable {
        case all = "Alle"
        case unfulfilled = "Offen"
        case fulfilled = "Erledigt"
    }

    private func generateDays() -> [CalendarDay] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (0...6).reversed().map { offset in
            let date = calendar.date(byAdding: .day, value: -offset, to: today)!
            return CalendarDay(
                day: date.formatted(.dateTime.weekday(.short)),
                date: date.formatted(.dateTime.day()),
                fullDate: date
            )
        }
    }

    // Filtert nur Habits mit Ziel < 10 (Merkliste)
    var filteredHabits: [Habit] {
        let dashboardOnlyHabits = store.habits.filter { $0.totalGoal < 10 }
        
        switch filterSelection {
        case .all:
            return dashboardOnlyHabits
        case .unfulfilled:
            return dashboardOnlyHabits.filter { $0.currentPunches < $0.totalGoal }
        case .fulfilled:
            return dashboardOnlyHabits.filter { $0.currentPunches >= $0.totalGoal }
        }
    }

    var body: some View {
        let allDays = generateDays()
        
        ZStack {
            cozyBg.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    filterMenu
                    Spacer()
                    dateStatus(for: allDays[selectedDateIndex].fullDate)
                }
                .padding(.horizontal, 25)
                .padding(.top, 15)
                
                calendarBar(days: allDays).padding(.top, 25)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Merkliste")
                        .font(.system(size: 40, weight: .heavy, design: .rounded))
                        .foregroundColor(Color.black.opacity(0.8))
                    
                    HStack(spacing: 8) {
                        Image(systemName: "heart.fill").font(.system(size: 10))
                        Text("Done is better than perfect!")
                    }
                    .font(.system(size: 16, weight: .semibold, design: .serif))
                    .italic()
                    .foregroundColor(deepGold)
                }
                .padding(.horizontal, 25).padding(.top, 30)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 12) {
                        if filteredHabits.isEmpty {
                            emptyState
                        } else {
                            ForEach(filteredHabits) { habit in
                                HabitRowView(habit: habit)
                                    .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
                            }
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 20)
                    .padding(.bottom, 150)
                }
            }
            
            floatingActionButton.zIndex(1)
        }
        .sheet(isPresented: $showingAddSheet) {
            AddDashboardView()
                .environment(store)
        }
    }

    // --- Private Hilfskomponenten ---

    private var filterMenu: some View {
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
            .foregroundColor(.white)
            .padding(.horizontal, 16).padding(.vertical, 8)
            .background(mellowAccent)
            .clipShape(Capsule())
        }
    }

    private func dateStatus(for date: Date) -> some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text("STAND")
                .font(.system(size: 10, weight: .black, design: .rounded))
                .kerning(1.2).foregroundColor(.secondary.opacity(0.5))
            Text(date.formatted(.dateTime.day().month(.abbreviated)))
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(deepGold)
        }
    }

    private func calendarBar(days: [CalendarDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(0..<days.count, id: \.self) { index in
                let isSelected = (selectedDateIndex == index)
                let isToday = (index == 6)
                
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        selectedDateIndex = index
                    }
                }) {
                    VStack(spacing: 10) {
                        Text(days[index].day)
                            .font(.system(size: 13, weight: isSelected ? .bold : .medium, design: .rounded))
                            .foregroundColor(isSelected ? .black : .secondary.opacity(0.4))
                        
                        Text(days[index].date)
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
            }
        }
        .padding(.horizontal, 15)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Spacer().frame(height: 40)
            Image(systemName: "sun.max.fill")
                .font(.system(size: 40))
                .foregroundColor(mellowAccent.opacity(0.5))
            Text("Alles erledigt für heute!")
                .font(.system(size: 16, weight: .medium, design: .serif))
                .foregroundColor(.secondary)
        }
    }

    private var floatingActionButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    showingAddSheet = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 68, height: 68)
                        .background(
                            Circle()
                                .fill(mellowAccent)
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        )
                        .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
                }
                .padding(.trailing, 25)
                .padding(.bottom, 110)
            }
        }
    }
}

// MARK: - HabitRowView

struct HabitRowView: View {
    var habit: Habit
    
    private let deepGold = Color(red: 0.75, green: 0.55, blue: 0.10)
    private let softSand = Color(red: 0.98, green: 0.96, blue: 0.92)
    
    var isDone: Bool {
        habit.currentPunches >= habit.totalGoal
    }
    
    var body: some View {
        @Bindable var bindableHabit = habit
        
        HStack(spacing: 16) {
            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                withAnimation(.spring()) {
                    if isDone {
                        bindableHabit.currentPunches = 0
                    } else {
                        bindableHabit.currentPunches = habit.totalGoal
                    }
                }
            }) {
                ZStack {
                    Circle()
                        .fill(isDone ? deepGold : Color.white)
                        .frame(width: 32, height: 32)
                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                    
                    if isDone {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    } else {
                        Circle()
                            .stroke(Color.black.opacity(0.1), lineWidth: 1.5)
                            .frame(width: 32, height: 32)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())

            VStack(alignment: .leading, spacing: 2) {
                Text(habit.title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(isDone ? .black.opacity(0.6) : .black.opacity(0.8))
                    .strikethrough(isDone, color: deepGold.opacity(0.4))
                    .lineLimit(1)
                
                Text(habit.time)
                    .font(.system(size: 14, weight: .medium, design: .serif))
                    .italic()
                    .foregroundColor(isDone ? .black.opacity(0.3) : .black.opacity(0.6))
            }
            
            Spacer()
            
            Image(systemName: isDone ? "sparkles" : habit.icon)
                .font(.system(size: 14))
                .foregroundColor(isDone ? deepGold.opacity(0.8) : Color.black.opacity(0.2))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(softSand)
        )
    }
}

// MARK: - Preview mit dem zentralen Store

#Preview {
    let previewStore = HabitStore()

    return DashboardView()
        .environment(previewStore)
}
