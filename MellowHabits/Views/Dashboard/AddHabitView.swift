import SwiftUI

struct AddHabitView: View {
    @Environment(HabitStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var time = Date()
    private let goal = 1
    
    private let deepGold = Color(red: 0.75, green: 0.55, blue: 0.10)
    private let cozyBg = Color(red: 0.96, green: 0.93, blue: 0.88)
    private let softSand = Color(red: 0.98, green: 0.96, blue: 0.92)
    
    var body: some View {
        NavigationStack {
            ZStack {
                cozyBg.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Button("Abbrechen") { dismiss() }
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("Neuer Eintrag")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(.black.opacity(0.8))
                        
                        Spacer()
                        
                        Button("Hinzufügen") {
                            saveAndDismiss()
                        }
                        .fontWeight(.bold)
                        .foregroundColor(title.isEmpty ? .secondary : deepGold)
                        .disabled(title.isEmpty)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(cozyBg)

                    ScrollView {
                        VStack(alignment: .leading, spacing: 30) {
                            
                            // Eingabe: Titel
                            VStack(alignment: .leading, spacing: 10) {
                                headerLabel("WAS STEHT AN?")
                                
                                TextField("z.B. Minecraft-Garten pflegen...", text: $title)
                                    .font(.system(size: 18, weight: .medium, design: .rounded))
                                    .padding()
                                    .background(softSand)
                                    .cornerRadius(20)
                                    .overlay(inputBorder)
                            }
                            
                            // Eingabe: Zeitpunkt
                            VStack(alignment: .leading, spacing: 10) {
                                headerLabel("ZEITPUNKT")
                                
                                HStack {
                                    Image(systemName: "clock.fill")
                                        .foregroundColor(deepGold.opacity(0.5))
                                        .padding(.leading, 15)
                                    
                                    DatePicker("Uhrzeit", selection: $time, displayedComponents: .hourAndMinute)
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                        .labelsHidden()
                                        .padding()
                                    
                                    Text("Uhr")
                                        .font(.system(size: 14, weight: .bold, design: .rounded))
                                        .foregroundColor(.secondary)
                                        .padding(.trailing, 15)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(softSand)
                                .cornerRadius(20)
                                .overlay(inputBorder)
                            }
                            
                            // Deko-Element unten, damit es nicht zu kahl aussieht
                            VStack(spacing: 12) {
                                Divider().background(deepGold.opacity(0.1))
                                    .padding(.horizontal, 40)
                                
                                HStack(spacing: 6) {
                                    Image(systemName: "leaf.fill")
                                    Text("Einfach mal machen.")
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
            .toolbar(.hidden) // Wir nutzen unseren eigenen Header oben
        }
    }
    
    private func saveAndDismiss() {
        // Formatiert die Zeit als String für den Store
        let timeString = time.formatted(date: .omitted, time: .shortened)
        store.addHabit(title: title, time: timeString, goal: goal)
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

// Preview Funktion eingebaut
#Preview {
    AddHabitView()
        .environment(HabitStore())
}
