import Foundation
import Observation
import SwiftUI // Zwingend notwendig für IndexSet und Listen-Operationen

@Observable
class HabitStore {
    var habits: [Habit] = [] {
        didSet { save() }
    }
    
    init() { load() }
    
    func addHabit(title: String, time: String, goal: Int) {
        let newHabit = Habit(title: title, time: time, currentPunches: 0, totalGoal: goal)
        habits.append(newHabit)
    }
    
    func addPunch(to habit: Habit) {
        if habit.currentPunches < habit.totalGoal {
            habit.currentPunches += 1
            save()
        }
    }
    
    func deleteHabit(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets) 
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(habits)
            UserDefaults.standard.set(data, forKey: "SavedHabits")
        } catch {
            print("Fehler beim Speichern")
        }
    }
    
    private func load() {
        if let data = UserDefaults.standard.data(forKey: "SavedHabits") {
            do {
                self.habits = try JSONDecoder().decode([Habit].self, from: data)
            } catch {
                print("Fehler beim Laden")
            }
        }
    }
}
