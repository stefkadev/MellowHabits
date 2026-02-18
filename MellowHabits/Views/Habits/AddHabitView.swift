import SwiftUI

struct AddHabitView: View {
    @Bindable var habit: Habit
    @Environment(HabitStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    // Farbschema
    private let mellowAccent = Color(red: 0.98, green: 0.82, blue: 0.25)
    private let deepGold = Color(red: 0.75, green: 0.55, blue: 0.10)
    private let cozyBg = Color(red: 0.96, green: 0.93, blue: 0.88)
    private let softSand = Color(red: 0.98, green: 0.96, blue: 0.92)

    private let timeOptions = ["1x Tag", "1x Woche", "3x Woche", "Unregelmäßig"]
    private let availableIcons = ["star.fill", "heart.fill", "bolt.fill", "figure.run", "leaf.fill", "flame.fill", "moon.fill", "drop.fill", "trophy.fill", "sun.max.fill"]

    var body: some View {
        ZStack {
            cozyBg.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // --- Sektion: Titel ---
                    VStack(alignment: .leading, spacing: 10) {
                        headerLabel("ÜBERSCHRIFT")
                        TextField("Titel der Gewohnheit", text: $habit.title)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.black.opacity(0.8))
                            .padding()
                            .background(softSand)
                            .cornerRadius(20)
                            .overlay(inputBorder)
                    }
                    
                    // --- Sektion: Zeitpunkt ---
                    VStack(alignment: .leading, spacing: 10) {
                        headerLabel("HÄUFIGKEIT")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(timeOptions, id: \.self) { option in
                                    Button {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        habit.time = option
                                    } label: {
                                        Text(option)
                                            .font(.system(size: 14, weight: .bold, design: .rounded))
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 10)
                                            .background(habit.time == option ? deepGold : softSand)
                                            .foregroundColor(habit.time == option ? .white : deepGold.opacity(0.7))
                                            .cornerRadius(15)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(deepGold.opacity(0.1), lineWidth: 1)
                                            )
                                    }
                                }
                            }
                        }
                    }

                    // --- Sektion: Icon Auswahl ---
                    VStack(alignment: .leading, spacing: 10) {
                        headerLabel("STEMPEL-SYMBOL")
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 45))], spacing: 15) {
                            ForEach(availableIcons, id: \.self) { iconName in
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    habit.icon = iconName
                                } label: {
                                    Image(systemName: iconName)
                                        .font(.system(size: 20))
                                        .frame(width: 45, height: 45)
                                        .background(habit.icon == iconName ? mellowAccent : softSand)
                                        .foregroundColor(habit.icon == iconName ? .white : deepGold.opacity(0.6))
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(deepGold.opacity(0.1), lineWidth: 1))
                                }
                            }
                        }
                        .padding()
                        .background(softSand)
                        .cornerRadius(20)
                        .overlay(inputBorder)
                    }

                    // --- Sektion: Fortschritt ---
                    VStack(alignment: .leading, spacing: 10) {
                        headerLabel("AKTUELLER FORTSCHRITT (ZIEL: 10)")
                        VStack(spacing: 0) {
                            stepperRow(title: "Bereits erledigt", value: $habit.currentPunches, range: 0...10, icon: habit.icon)
                        }
                        .background(softSand)
                        .cornerRadius(20)
                        .overlay(inputBorder)
                    }
                    
                    // --- Löschen Button ---
                    if store.habits.contains(where: { $0.id == habit.id }) {
                        Button(role: .destructive) {
                            withAnimation {
                                store.habits.removeAll { $0.id == habit.id }
                                dismiss()
                            }
                        } label: {
                            Text("Punchcard löschen")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.red.opacity(0.7))
                                .frame(maxWidth: .infinity)
                        }
                        .padding(.top, 10)
                    }
                }
                .padding(25)
            }
        }
        .navigationTitle(habit.title.isEmpty ? "Neue Punchcard" : "Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Sicherstellen, dass Punchcards immer das Ziel 10 haben
            if habit.totalGoal != 10 { habit.totalGoal = 10 }
            if habit.time.isEmpty { habit.time = "1x Tag" }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Fertig") {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    // Falls neu, in den Store einfügen
                    if !store.habits.contains(where: { $0.id == habit.id }) {
                        store.habits.append(habit)
                    }
                    dismiss()
                }
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(habit.title.isEmpty ? Color.gray : deepGold)
                .disabled(habit.title.isEmpty)
            }
        }
    }

    private func headerLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .black, design: .rounded))
            .kerning(1.2)
            .foregroundColor(deepGold.opacity(0.6))
            .padding(.leading, 10)
    }

    private var inputBorder: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(deepGold.opacity(0.1), lineWidth: 1)
    }

    private func stepperRow(title: String, value: Binding<Int>, range: ClosedRange<Int>, icon: String) -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon.isEmpty ? "star.fill" : icon)
                .font(.system(size: 18))
                .foregroundColor(deepGold.opacity(0.5))
                .frame(width: 30)
            
            Text(title)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.black.opacity(0.8))
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: {
                    if value.wrappedValue > range.lowerBound {
                        value.wrappedValue -= 1
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(mellowAccent)
                }
                
                Text("\(value.wrappedValue)")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .frame(width: 30)
                    .foregroundColor(.black)
                
                Button(action: {
                    if value.wrappedValue < range.upperBound {
                        value.wrappedValue += 1
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(mellowAccent)
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
    }
}

// MARK: - Preview 
#Preview {
    NavigationStack {
        AddHabitView(habit: Habit(title: "Sport machen", time: "3x Woche", icon: "figure.run", currentPunches: 2, totalGoal: 10))
            .environment(HabitStore())
    }
}
