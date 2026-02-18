import SwiftUI

struct PunchCardLogic: View {
    @Bindable var habit: Habit
    @Environment(HabitStore.self) private var store
    
    private let mellowAccent = Color(red: 0.98, green: 0.82, blue: 0.25)
    private let deepGold = Color(red: 0.75, green: 0.55, blue: 0.10)

    private var isEightyPercentDone: Bool {
        let progress = Double(habit.currentPunches) / Double(habit.totalGoal)
        return progress >= 0.8 && habit.currentPunches < habit.totalGoal
    }

    private var activeIcon: String {
        habit.icon.isEmpty ? "star.fill" : habit.icon
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(habit.title)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.black.opacity(0.8))
                        if isEightyPercentDone {
                            Image(systemName: "sparkles")
                                .foregroundColor(deepGold)
                                .font(.system(size: 14))
                        }
                    }
                    
                    Label(habit.time, systemImage: "clock")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(deepGold.opacity(0.7))
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
            
            let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 5)
            
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(0..<habit.totalGoal, id: \.self) { index in
                    ZStack {
                        Circle()
                            .fill(Color.black.opacity(0.03))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Circle()
                                    .strokeBorder(Color.black.opacity(0.05), lineWidth: 1)
                            )
                        
                        if index < habit.currentPunches {
                            Image(systemName: activeIcon)
                                .font(.system(size: 22, weight: .black))
                                .foregroundColor(deepGold)
                                .mask(
                                    ZStack {
                                        Image(systemName: activeIcon)
                                            .font(.system(size: 22, weight: .black))
                                        Circle()
                                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [0.5, 2]))
                                            .frame(width: 28, height: 28)
                                            .blendMode(.destinationOut)
                                    }
                                )
                                .opacity(0.9)
                                .rotationEffect(.degrees(Double(index * 8).truncatingRemainder(dividingBy: 20) - 10))
                                .scaleEffect(1.1)
                                .transition(.asymmetric(
                                    insertion: .scale(scale: 2.0).combined(with: .opacity),
                                    removal: .opacity
                                ))
                        }
                    }
                }
            }
            .padding(.horizontal, 5)


            Button(action: {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    store.addPunch(to: habit)
                }
            }) {
                HStack {
                    Image(systemName: habit.currentPunches >= habit.totalGoal ? "checkmark.seal.fill" : "hand.tap.fill")
                    Text(habit.currentPunches >= habit.totalGoal ? "Karte voll!" : "Stempeln")
                }
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    Group {
                        if habit.currentPunches >= habit.totalGoal {
                            Color.green.opacity(0.15)
                        } else {
                            deepGold
                        }
                    }
                )
                .foregroundColor(habit.currentPunches >= habit.totalGoal ? .green : .white)
                .cornerRadius(16)
                .shadow(color: (habit.currentPunches >= habit.totalGoal ? Color.clear : deepGold.opacity(0.3)), radius: 8, x: 0, y: 4)
            }
            .disabled(habit.currentPunches >= habit.totalGoal)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(24)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color(red: 0.96, green: 0.93, blue: 0.88).ignoresSafeArea()
        VStack(spacing: 20) {
            PunchCardLogic(habit: Habit(title: "Code Projekt", time: "1x Tag", icon: "laptopcomputer", currentPunches: 9, totalGoal: 10))
        }
        .padding()
    }
    .environment(HabitStore())
}
