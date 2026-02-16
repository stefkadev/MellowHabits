import SwiftUI

struct HabitRowView: View {
    let habit: Habit
    
    // Einfache Logik für die Merkliste:
    // Ein Element gilt als "isDone", wenn mindestens ein Stempel/Punkt erreicht wurde
    // oder das Ziel (totalGoal) erfüllt ist.
    var isDone: Bool {
        habit.currentPunches >= habit.totalGoal
    }
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isDone ? .black : .black.opacity(0.2))
                .font(.system(size: 24))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(habit.title)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.bold)
                    .strikethrough(isDone, color: .black)
                    .foregroundColor(isDone ? .secondary : .primary)
                
                if !habit.time.isEmpty {
                    Text(habit.time)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(isDone ? 0.5 : 0.9))
        )
    }
}

// MARK: - Preview (Nur für diese View)
#Preview {
    ZStack {
        Color("MellowYellow").ignoresSafeArea()
        VStack {
            HabitRowView(habit: Habit(title: "Wäsche waschen", time: "Morgens", currentPunches: 0, totalGoal: 1))
            HabitRowView(habit: Habit(title: "Hausaufgaben", time: "14:00", currentPunches: 1, totalGoal: 1))
        }
        .padding()
    }
}
