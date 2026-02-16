import SwiftUI

struct PunchCardView: View {
    var habit: Habit
    @Environment(HabitStore.self) private var store
    
    private let mellowAccent = Color(red: 0.98, green: 0.82, blue: 0.25)
    private let deepGold = Color(red: 0.75, green: 0.55, blue: 0.10)

    private var isEightyPercentDone: Bool {
        let progress = Double(habit.currentPunches) / Double(habit.totalGoal)
        return progress >= 0.8 && habit.currentPunches < habit.totalGoal
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(habit.title)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                        if isEightyPercentDone {
                            Image(systemName: "star.fill")
                                .foregroundColor(deepGold)
                                .font(.system(size: 14))
                        }
                    }
                    Label(habit.time, systemImage: "clock")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }
                Spacer()
                
                Text("\(habit.currentPunches) / \(habit.totalGoal)")
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(isEightyPercentDone || habit.currentPunches == habit.totalGoal ? .white : deepGold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(isEightyPercentDone || habit.currentPunches == habit.totalGoal ? deepGold : mellowAccent.opacity(0.15))
                    .cornerRadius(12)
            }
            
            // Das 2x5 Raster (Fixiert auf 5 Spalten)
            let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 5)
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(0..<habit.totalGoal, id: \.self) { index in
                    ZStack {
                        Circle()
                            .fill(index < habit.currentPunches ? mellowAccent : Color.gray.opacity(0.1))
                            .frame(width: 35, height: 35)
                        
                        if index < habit.currentPunches {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .black))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .padding(.horizontal, 5)
            
            // Stempel-Button
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    store.addPunch(to: habit)
                }
            }) {
                Text(isEightyPercentDone ? "Fast geschafft! ✨" : (habit.currentPunches >= habit.totalGoal ? "Perfekt!" : "Stempeln"))
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(habit.currentPunches >= habit.totalGoal ? Color.green.opacity(0.15) : (isEightyPercentDone ? deepGold : mellowAccent))
                    .foregroundColor(habit.currentPunches >= habit.totalGoal ? .green : .white)
                    .cornerRadius(16)
                    .shadow(color: habit.currentPunches < habit.totalGoal ? (isEightyPercentDone ? deepGold : mellowAccent).opacity(0.3) : .clear, radius: 8, y: 4)
            }
            .disabled(habit.currentPunches >= habit.totalGoal)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(isEightyPercentDone ? deepGold.opacity(0.5) : Color.clear, lineWidth: 2)
        )
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color(red: 0.96, green: 0.93, blue: 0.88).ignoresSafeArea()
        VStack(spacing: 20) {
            
            PunchCardView(habit: Habit(title: "10k Schritte", time: "Täglich", currentPunches: 8, totalGoal: 10))
            
            PunchCardView(habit: Habit(title: "Code lesen", time: "Morgens", currentPunches: 2, totalGoal: 10))
        }
        .padding()
    }
    .environment(HabitStore())
}
