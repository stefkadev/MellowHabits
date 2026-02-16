import SwiftUI

struct AddHabitView: View {
    @Environment(HabitStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var time = Date()
    @State private var goal = 5
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Was möchtest du tracken?") {
                    TextField("Name der Gewohnheit", text: $title)
                }
                
                Section("Details") {
                    DatePicker("Uhrzeit", selection: $time, displayedComponents: .hourAndMinute)
                    Stepper("Ziel: \(goal) Stempel", value: $goal, in: 1...10)
                }
            }
            .navigationTitle("Neue Gewohnheit")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") {
                        let timeString = time.formatted(date: .omitted, time: .shortened)
                        store.addHabit(title: title, time: timeString, goal: goal)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}
