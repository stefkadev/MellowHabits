import SwiftUI

struct HabitDetailView: View {
    @Bindable var habit: Habit
    @Environment(HabitStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    // Farbschema passend zur AddHabitView
    private let mellowAccent = Color(red: 0.98, green: 0.82, blue: 0.25)
    private let deepGold = Color(red: 0.75, green: 0.55, blue: 0.10)
    private let cozyBg = Color(red: 0.96, green: 0.93, blue: 0.88)
    private let softSand = Color(red: 0.98, green: 0.96, blue: 0.92)

    var body: some View {
        ZStack {
            cozyBg.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    
                    // --- Sektion: Titel ---
                    VStack(alignment: .leading, spacing: 10) {
                        headerLabel("ÜBERSCHRIFT")
                        
                        TextField("Titel der Gewohnheit", text: $habit.title)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .padding()
                            .background(softSand)
                            .cornerRadius(20)
                            .overlay(inputBorder)
                    }
                    
                    // --- Sektion: Zeitpunkt ---
                    VStack(alignment: .leading, spacing: 10) {
                        headerLabel("ZEITPUNKT")
                        
                        TextField("z.B. Morgens, Täglich...", text: $habit.time)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .padding()
                            .background(softSand)
                            .cornerRadius(20)
                            .overlay(inputBorder)
                    }

                    // --- Sektion: Fortschritt (Stepper) ---
                    VStack(alignment: .leading, spacing: 10) {
                        headerLabel("FORTSCHRITT & ZIEL")
                        
                        VStack(spacing: 0) {
                            stepperRow(title: "Aktuelle Stempel", value: $habit.currentPunches, range: 0...habit.totalGoal, icon: "checkmark.seal.fill")
                            Divider().background(deepGold.opacity(0.1)).padding(.horizontal)
                            stepperRow(title: "Gesamtziel", value: $habit.totalGoal, range: 1...25, icon: "target")
                        }
                        .background(softSand)
                        .cornerRadius(20)
                        .overlay(inputBorder)
                    }
                    
                    // --- Footer / Löschen ---
                    VStack(spacing: 15) {
                        Divider().background(deepGold.opacity(0.1))
                            .padding(.horizontal, 40)
                        
                        Button(role: .destructive) {
                            // Hier könnte store.delete(habit) stehen
                            dismiss()
                        } label: {
                            Text("Gewohnheit löschen")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.red.opacity(0.7))
                        }
                    }
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity)
                }
                .padding(25)
            }
        }
        .navigationTitle("Bearbeiten")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Fertig") {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    store.save()
                    dismiss()
                }
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(deepGold)
            }
        }
    }

    // Hilfskomponenten für das einheitliche Design
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
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(deepGold.opacity(0.5))
                .frame(width: 30)
            
            Text(title)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
            
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

// MARK: - Preview (Immer dabei)
#Preview {
    NavigationStack {
        HabitDetailView(habit: Habit(title: "Code Projekt", time: "10:00 Uhr", currentPunches: 3, totalGoal: 10))
            .environment(HabitStore())
    }
}
