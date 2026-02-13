import SwiftUI

struct DashboardView: View {
    @Environment(HabitStore.self) private var store
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("MellowYellow").ignoresSafeArea()
                
                List {
                    ForEach(store.habits) { habit in
                        // NavigationLink erlaubt das Öffnen der Detailansicht
                        NavigationLink(destination: HabitDetailView(habit: habit)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(habit.title)
                                        .font(.headline)
                                    Text(habit.time)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text("\(habit.currentPunches)/\(habit.totalGoal)")
                                    .font(.caption)
                                    .padding(6)
                                    .background(Color.yellow.opacity(0.3))
                                    .cornerRadius(8)
                            }
                        }
                        .listRowBackground(Color.white.opacity(0.5))
                    }
                    .onDelete(perform: store.deleteHabit)
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Meine Merkliste")
            }
        }
    }
}
