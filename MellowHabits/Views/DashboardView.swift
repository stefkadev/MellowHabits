import SwiftUI

struct DashboardView: View {
    @Environment(HabitStore.self) private var store
    @State private var showingAddSheet = false
    @State private var filterSelection: FilterType = .all
    
    enum FilterType: String, CaseIterable {
        case all = "Alle"
        case unfulfilled = "Unerfüllt"
        case fulfilled = "Erfüllt"
    }

    var filteredHabits: [Habit] {
        switch filterSelection {
        case .all:
            return store.habits
        case .unfulfilled:
            return store.habits.filter { $0.currentPunches < $0.totalGoal }
        case .fulfilled:
            return store.habits.filter { $0.currentPunches >= $0.totalGoal }
        }
    }

    var body: some View {
        ZStack {
            Color("MellowYellow").ignoresSafeArea(edges: .top)
            
            VStack(alignment: .leading, spacing: 25) {
                headerSection
                
                Text("Merkliste")
                    .font(.system(size: 40, weight: .black, design: .rounded))
                    .padding(.horizontal)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 12) {
                        ForEach(filteredHabits) { habit in
                            HabitRowView(habit: habit)
                        }
                        
                        if filteredHabits.isEmpty {
                            Text("Keine Einträge gefunden")
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(.secondary)
                                .padding(.top, 40)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 120)
                }
            }
            
            floatingActionButton
        }
        .sheet(isPresented: $showingAddSheet) {
            AddHabitView()
        }
        .onAppear { ensureInitialElements() }
    }

    // MARK: - Subviews
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Menu {
                    Picker("Filter", selection: $filterSelection) {
                        ForEach(FilterType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(filterSelection.rawValue)
                        Image(systemName: "chevron.down").font(.system(size: 10))
                    }
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.5))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(Color.black.opacity(0.1), lineWidth: 1)
                    )
                }
                
                Spacer()
                Text("Heute").font(.system(size: 18, weight: .bold, design: .rounded))
                Spacer()
                Color.clear.frame(width: 40, height: 1)
            }
            
            calendarHorizontalBar
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }

    private var calendarHorizontalBar: some View {
        HStack(spacing: 0) {
            ForEach(0..<7) { index in
                let days = ["Di", "Mi", "Do", "Fr", "Sa", "So", "Mo"]
                let dates = ["10", "11", "12", "13", "14", "15", "16"]
                let isToday = (index == 6)
                
                VStack(spacing: 12) {
                    Text(days[index])
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    Text(dates[index])
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .frame(width: 36, height: 36)
                        .background(
                            ZStack {
                                if isToday {
                                    Capsule()
                                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
                                        .frame(width: 44, height: 70)
                                        .offset(y: -15)
                                }
                                Circle().stroke(Color.gray.opacity(0.1), lineWidth: 1)
                            }
                        )
                        .foregroundColor(isToday ? .primary : .secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    private var floatingActionButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: { showingAddSheet = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.black)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                }
                .padding(25)
            }
        }
    }

    private func ensureInitialElements() {
        store.habits.removeAll()
        
        // Reine Text-Beispiele ohne Emojis
        store.addHabit(title: "Die Gemeinde pflegen", time: "Vormittags", goal: 1)
        store.addHabit(title: "Looten und Leveln", time: "Nach der Arbeit", goal: 1)
        store.addHabit(title: "Kohlenhydrate sammeln", time: "Abendbrot", goal: 1)
        
        if let lastHabit = store.habits.last {
            lastHabit.currentPunches = 1
        }
    }
}

// MARK: - Preview
#Preview {
    let mockStore = HabitStore()
    return DashboardView()
        .environment(mockStore)
}
