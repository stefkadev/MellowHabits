import SwiftUI

struct HabitRowView: View {
    @Bindable var habit: Habit
    private let deepGold = Color(red: 0.75, green: 0.55, blue: 0.10)
    private let softSand = Color(red: 0.98, green: 0.96, blue: 0.92)
    
    var body: some View {
        HStack(spacing: 16) {
            // Check-Button
            Button(action: {
                if habit.currentPunches >= habit.totalGoal {
                    habit.currentPunches = 0
                } else {
                    habit.currentPunches = habit.totalGoal
                }
            }) {
                ZStack {
                    Circle()
                        .fill(habit.currentPunches >= habit.totalGoal ? deepGold : Color.white)
                        .frame(width: 32, height: 32)
                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                    
                    if habit.currentPunches >= habit.totalGoal {
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
                    .foregroundColor(habit.currentPunches >= habit.totalGoal ? .secondary.opacity(0.5) : .black.opacity(0.8))
                    .strikethrough(habit.currentPunches >= habit.totalGoal, color: deepGold.opacity(0.3))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(habit.time)
                    .font(.system(size: 13, weight: .medium, design: .serif))
                    .italic()
                    .foregroundColor(.secondary.opacity(0.6))
            }
            
            Spacer()
            
            // Belohnung-Icon
            Image(systemName: habit.currentPunches >= habit.totalGoal ? "sparkles" : "leaf.fill")
                .font(.system(size: 14))
                .foregroundColor(habit.currentPunches >= habit.totalGoal ? deepGold.opacity(0.6) : Color.black.opacity(0.05))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(softSand)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.black.opacity(0.03), lineWidth: 1)
        )
    }
}

// MARK: - Preview
#Preview {
    let testHabit = Habit(title: "Kohle, Kohle, Kohle sammeln", time: "Täglich", currentPunches: 0, totalGoal: 1)
    
    ZStack {
        Color(red: 0.99, green: 0.98, blue: 0.94).ignoresSafeArea()
        VStack(spacing: 15) {
            HabitRowView(habit: testHabit)
            HabitRowView(habit: Habit(title: "Looten und Leveln", time: "Abends", currentPunches: 1, totalGoal: 1))
        }
        .padding()
    }
}
