import SwiftUI

struct PunchCardView: View {
    var habit: Habit
    
    @Environment(HabitStore.self) private var store
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Oberer Bereich: Titel und Uhrzeit
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.title)
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.bold)
                    
                    Label(habit.time, systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Fortschritts-Anzeige
                Text("\(habit.currentPunches) / \(habit.totalGoal)")
                    .font(.system(.subheadline, design: .monospaced))
                    .fontWeight(.semibold)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(8)
            }
            
            // "Stempelkarte" - Visualisierung
            HStack(spacing: 8) {
                ForEach(0..<habit.totalGoal, id: \.self) { index in
                    Circle()
                        .fill(index < habit.currentPunches ? Color.yellow : Color.gray.opacity(0.2))
                        .frame(width: 25, height: 25)
                        .overlay(
                            Circle()
                                .stroke(Color.black.opacity(0.1), lineWidth: 1)
                        )
                }
            }
            
            // Interaktions-Button
            Button(action: {
                withAnimation(.spring()) {
                    store.addPunch(to: habit)
                }
            }) {
                Text(habit.currentPunches >= habit.totalGoal ? "Abgeschlossen!" : "Stempeln")
                    .font(.footnote.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(habit.currentPunches >= habit.totalGoal ? Color.green.opacity(0.2) : Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
            .disabled(habit.currentPunches >= habit.totalGoal)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
        // Visuelles Feedback für das 80%-Feature
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(habit.isCelebrated ? Color.yellow : Color.clear, lineWidth: 2)
        )
    }
}

#Preview {
    // Preview mit Mock-Daten
    let mockStore = HabitStore()
    PunchCardView(habit: Habit(title: "Preview Habit", time: "10:00", currentPunches: 2, totalGoal: 5))
        .environment(mockStore)
        .padding()
        .background(Color("MellowYellow"))
}
#Preview {
    let mockHabit = Habit(title: "Trinken", time: "Ganztägig", currentPunches: 2, totalGoal: 8)
    let mockStore = HabitStore()
    
    return PunchCardView(habit: mockHabit)
        .environment(mockStore)
}
