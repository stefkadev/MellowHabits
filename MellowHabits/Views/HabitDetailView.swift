import SwiftUI

struct HabitDetailView: View {
    @Bindable var habit: Habit
    @Environment(HabitStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color("MellowYellow").ignoresSafeArea()
            
            Form {
                Section(header: Text("Stammdaten")) {
                    TextField("Titel", text: $habit.title)
                    TextField("Geplante Uhrzeit", text: $habit.time)
                }
                
                Section(header: Text("Fortschritt & Ziele")) {
                    Stepper("Aktuelle Stempel: \(habit.currentPunches)",
                            value: $habit.currentPunches,
                            in: 0...habit.totalGoal)
                    
                    Stepper("Gesamtziel: \(habit.totalGoal)",
                            value: $habit.totalGoal,
                            in: 1...30)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Gewohnheit bearbeiten")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Fertig") {
                    store.save()
                    dismiss()
                }
            }
        }
    }
}
