import SwiftUI

struct AddDashboardView: View {
    @Environment(HabitStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var selectedTime = "Morgens" // Standardauswahl
    private let goal = 1
    
    // Farbschema (angepasst an AddHabitView)
    private let mellowAccent = Color(red: 0.98, green: 0.82, blue: 0.25)
    private let deepGold = Color(red: 0.75, green: 0.55, blue: 0.10)
    private let cozyBg = Color(red: 0.96, green: 0.93, blue: 0.88)
    private let softSand = Color(red: 0.98, green: 0.96, blue: 0.92)
    
    // Dashboard Optionen
    private let timeOptions = ["Morgens", "Mittags", "Abends"]

    var body: some View {
        NavigationStack {
            ZStack {
                cozyBg.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom Header (Look von AddHabitView/Dashboard)
                    HStack {
                        Button("Abbrechen") { dismiss() }
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("Neuer Eintrag")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(.black.opacity(0.8))
                        
                        Spacer()
                        
                        Button("Fertig") {
                            saveAndDismiss()
                        }
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(title.isEmpty ? .secondary : deepGold)
                        .disabled(title.isEmpty)
                    }
                    .padding(.horizontal, 25)
                    .padding(.vertical, 15)
                    .background(cozyBg)

                    ScrollView {
                        VStack(alignment: .leading, spacing: 30) {
                            
                            // --- Sektion: Titel ---
                            VStack(alignment: .leading, spacing: 10) {
                                headerLabel("WAS STEHT AN?")
                                
                                TextField("z.B. Minecraft-Garten pflegen...", text: $title)
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(.black.opacity(0.8))
                                    .padding()
                                    .background(softSand)
                                    .cornerRadius(20)
                                    .overlay(inputBorder)
                            }
                            
                            // --- Sektion: Zeitpunkt (Die neuen Buttons) ---
                            VStack(alignment: .leading, spacing: 10) {
                                headerLabel("ZEITPUNKT")
                                
                                HStack(spacing: 12) {
                                    ForEach(timeOptions, id: \.self) { option in
                                        Button {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            selectedTime = option
                                        } label: {
                                            Text(option)
                                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 14)
                                                .background(selectedTime == option ? deepGold : softSand)
                                                .foregroundColor(selectedTime == option ? .white : deepGold.opacity(0.7))
                                                .cornerRadius(15)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .stroke(deepGold.opacity(0.1), lineWidth: 1)
                                                )
                                        }
                                    }
                                }
                            }
                            
                            // Deko-Element unten
                            VStack(spacing: 12) {
                                Divider().background(deepGold.opacity(0.1))
                                    .padding(.horizontal, 40)
                                
                                HStack(spacing: 6) {
                                    Image(systemName: "leaf.fill")
                                    Text("Done is better than perfect!")
                                }
                                .font(.system(size: 13, weight: .medium, design: .serif))
                                .italic()
                                .foregroundColor(deepGold.opacity(0.4))
                            }
                            .padding(.top, 40)
                            .frame(maxWidth: .infinity)
                        }
                        .padding(25)
                    }
                }
            }
            .toolbar(.hidden)
        }
    }
    
    private func saveAndDismiss() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        // Wir speichern hier mit einem Standard-Icon (z.B. List),
        // da Dashboard-Einträge meist schnell gehen sollen.
        store.addHabit(title: title, time: selectedTime, goal: goal)
        dismiss()
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
}

// MARK: - Preview
#Preview {
    AddDashboardView()
        .environment(HabitStore())
}
