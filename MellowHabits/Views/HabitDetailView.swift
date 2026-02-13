import SwiftUI

struct HabitDetailView: View {
    @Bindable var habit: Habit
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color("MellowYellow").ignoresSafeArea()
            
            Form {
                Section("Bearbeiten") {
                    TextField("Titel", text: $habit.title)
                    TextField("Zeit", text: $habit.time)
                }
                
                Section("Fortschritt") {
                    // WICHTIG: Nutze $ für das Binding beim Stepper
                    Stepper("Stempel: \(habit.currentPunches)", value: $habit.currentPunches, in: 0...habit.totalGoal)
                    Stepper("Ziel: \(habit.totalGoal)", value: $habit.totalGoal, in: 1...20)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Fertig") { dismiss() }
        }
    }
}
