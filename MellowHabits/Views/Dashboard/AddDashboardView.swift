import SwiftUI

struct AddDashboardView: View {
    @Environment(HabitStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    
    var habitToEdit: Habit?
    
    @State private var title = ""
    @State private var selectedTime = "Morgens"
    @State private var notes = ""
    @State private var isHighPriority = false
    @State private var selectedIcon = "leaf.fill"
    
    private let mellowAccent = Color(red: 0.98, green: 0.82, blue: 0.25)
    private let deepGold = Color(red: 0.75, green: 0.55, blue: 0.10)
    private let cozyBg = Color(red: 0.96, green: 0.93, blue: 0.88)
    private let softSand = Color(red: 0.98, green: 0.96, blue: 0.92)
    
    private let timeOptions = ["Morgens", "Mittags", "Abends"]
    private let icons = ["leaf.fill", "frying.pan", "mouth", "bitcoinsign.circle", "star.fill", "heart.fill", "bolt.fill", "tent.fill"]

    var body: some View {
        NavigationStack {
            ZStack {
                cozyBg.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        VStack(alignment: .leading, spacing: 10) {
                            headerLabel("NAME")
                            TextField("z.B. Minecraft-Garten pflegen...", text: $title)
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.black) 
                                .padding()
                                .background(softSand)
                                .cornerRadius(20)
                                .overlay(inputBorder)
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            headerLabel("ICON")
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(icons, id: \.self) { icon in
                                        Image(systemName: icon)
                                            .font(.system(size: 22))
                                            .foregroundColor(selectedIcon == icon ? .white : deepGold)
                                            .frame(width: 50, height: 50)
                                            .background(selectedIcon == icon ? deepGold : softSand)
                                            .clipShape(Circle())
                                            .onTapGesture {
                                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                                selectedIcon = icon
                                            }
                                    }
                                }
                                .padding(.horizontal, 5)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            headerLabel("HÄUFIGKEIT")
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
                                    }
                                }
                            }
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            headerLabel("NOTIZEN")
                            TextField("Zusätzliche Gedanken...", text: $notes, axis: .vertical)
                                .lineLimit(3...5)
                                .font(.system(size: 16, design: .rounded))
                                .foregroundColor(.black) // Textlesbarkeit gefixt
                                .padding()
                                .background(softSand)
                                .cornerRadius(20)
                                .overlay(inputBorder)
                        }

                        Toggle(isOn: $isHighPriority) {
                            Text("Besonders wichtig?")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(deepGold)
                        }
                        .tint(mellowAccent)
                        .padding()
                        .background(softSand)
                        .cornerRadius(20)
                        .overlay(inputBorder)
                    }
                    .padding(25)
                }
            }
            .onAppear {
                if let habit = habitToEdit {
                    title = habit.title
                    selectedTime = habit.time
                    notes = habit.notes
                    isHighPriority = habit.isHighPriority
                    selectedIcon = habit.icon
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fertig") { saveAndDismiss() }
                        .foregroundColor(title.isEmpty ? .secondary : deepGold)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen") { dismiss() }
                }
            }
        }
    }
    
    private func saveAndDismiss() {
        if let habit = habitToEdit {
            habit.title = title
            habit.time = selectedTime
            habit.notes = notes
            habit.isHighPriority = isHighPriority
            habit.icon = selectedIcon
        } else {
            store.addHabit(title: title, time: selectedTime, icon: selectedIcon, goal: 1, notes: notes, isHighPriority: isHighPriority)
        }
        dismiss()
    }

    private func headerLabel(_ text: String) -> some View {
        Text(text).font(.system(size: 11, weight: .black, design: .rounded)).kerning(1.2).foregroundColor(deepGold.opacity(0.6))
    }
    
    private var inputBorder: some View {
        RoundedRectangle(cornerRadius: 20).stroke(deepGold.opacity(0.1), lineWidth: 1)
    }
}
