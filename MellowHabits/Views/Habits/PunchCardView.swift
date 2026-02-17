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

    // Kraftvolle Icons, die zu fast jeder Gewohnheit passen
    private var stampIcon: String {
        let icons = ["bolt.fill", "star.fill", "flame.fill", "heart.fill", "crown.fill", "checkmark.seal.fill", "trophy.fill"]
        let hash = abs(habit.title.hashValue)
        return icons[hash % icons.count]
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
                            Image(systemName: "sparkles")
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
            
            // Raster
            let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 5)
            
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(0..<habit.totalGoal, id: \.self) { index in
                    ZStack {
                        // Der leere Slot
                        Circle()
                            .fill(Color.black.opacity(0.03))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Circle()
                                    .strokeBorder(Color.black.opacity(0.05), lineWidth: 1)
                            )
                        
                        if index < habit.currentPunches {
                            // Der Stempel mit "Tinten-Struktur"
                            Image(systemName: stampIcon)
                                .font(.system(size: 24, weight: .black))
                                .foregroundColor(deepGold)
                                // Der Clou: Eine Maske aus vielen kleinen Punkten für den Stempel-Look
                                .mask(
                                    ZStack {
                                        Image(systemName: stampIcon)
                                            .font(.system(size: 24, weight: .black))
                                        
                                        // "Abnutzung" simulieren
                                        Circle()
                                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [0.5, 2]))
                                            .frame(width: 30, height: 30)
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
            
            // Stempel-Button
            Button(action: {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    store.addPunch(to: habit)
                }
            }) {
                HStack {
                    Image(systemName: habit.currentPunches >= habit.totalGoal ? "checkmark.seal.fill" : "square.and.pencil")
                    Text(habit.currentPunches >= habit.totalGoal ? "Karte voll!" : "Stempel aufdrücken")
                }
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(habit.currentPunches >= habit.totalGoal ? Color.green.opacity(0.15) : (isEightyPercentDone ? deepGold : mellowAccent))
                .foregroundColor(habit.currentPunches >= habit.totalGoal ? .green : .white)
                .cornerRadius(16)
            }
            .disabled(habit.currentPunches >= habit.totalGoal)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.05), radius: 10, y: 5)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color(red: 0.96, green: 0.93, blue: 0.88).ignoresSafeArea()
        VStack(spacing: 20) {
            PunchCardView(habit: Habit(title: "Code Projekt", time: "Täglich", currentPunches: 9, totalGoal: 10))
            PunchCardView(habit: Habit(title: "Sport machen", time: "3x Woche", currentPunches: 3, totalGoal: 10))
        }
        .padding()
    }
    .environment(HabitStore())
}
