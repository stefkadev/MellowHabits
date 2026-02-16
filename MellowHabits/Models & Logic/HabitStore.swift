import Foundation
import Observation
import SwiftUI

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
    
    // MARK: - Alles zurücksetzen
    func clearAllData() {
        habits.removeAll()
        UserDefaults.standard.removeObject(forKey: "SavedHabits")
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
                let decoded = try JSONDecoder().decode([Habit].self, from: data)
                self.habits = decoded
            } catch {
                print("Fehler beim Laden")
            }
        }
    }
}
