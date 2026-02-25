import Foundation
import Observation
import SwiftUI

@Observable
class HabitStore {
    var habits: [Habit] = [] {
        didSet { save() }
    }
    
    init() {
        load()
        if habits.isEmpty {
            addSampleData()
        }
    }
    
    func addSampleData() {
        addHabit(title: "Pfanne im Wald suchen", time: "Morgens", icon: "frying.pan", goal: 1)
        addHabit(title: "Ein freundliches 'Hering!' rufen", time: "Mittags", icon: "mouth", goal: 1)
        addHabit(title: "Kohle? KOHLE!", time: "Abends", icon: "bitcoinsign.circle", goal: 1)
        
        addHabit(title: "Lurche grüßen", time: "Täglich", icon: "lizard.fill", goal: 10)
        addHabit(title: "Im Inventar kramen", time: "3x Woche", icon: "archivebox.fill", goal: 10)
        addHabit(title: "Schon GEZahlt?", time: "Unregelmäßig", icon: "tv", goal: 10)
        
        if let lurchHabit = habits.first(where: { $0.title == "Lurche grüßen" }) {
            for _ in 0..<7 {
                lurchHabit.currentPunches += 1
                lurchHabit.punchDates.append(Date())
            }
        }
        save()
    }
    
    func addHabit(title: String, time: String, icon: String = "star.fill", goal: Int, notes: String = "", isHighPriority: Bool = false) {
        if !habits.contains(where: { $0.title == title }) {
            let newHabit = Habit(
                title: title,
                time: time,
                icon: icon,
                currentPunches: 0,
                totalGoal: goal,
                punchDates: [],
                notes: notes,
                isHighPriority: isHighPriority
            )
            habits.append(newHabit)
        }
    }
    
    func addPunch(to habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            if habits[index].currentPunches < habits[index].totalGoal {
                habits[index].currentPunches += 1
                habits[index].punchDates.append(Date())
                save()
            }
        }
    }
    
    func toggleHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            if habits[index].currentPunches == 0 {
                habits[index].currentPunches = 1
                habits[index].punchDates.append(Date())
            } else {
                habits[index].currentPunches = 0
                if !habits[index].punchDates.isEmpty {
                    habits[index].punchDates.removeLast()
                }
            }
            save()
        }
    }
    
    func deleteHabit(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
    }
    
    func deleteHabit(_ habit: Habit) {
        habits.removeAll { $0.id == habit.id }
    }
    
    func clearAllData() {
        habits.removeAll()
        UserDefaults.standard.removeObject(forKey: "SavedHabits")
        addSampleData()
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(habits)
            UserDefaults.standard.set(data, forKey: "SavedHabits")
        } catch {
            print("Fehler beim Speichern: \(error)")
        }
    }
    
    private func load() {
        if let data = UserDefaults.standard.data(forKey: "SavedHabits") {
            do {
                let decoded = try JSONDecoder().decode([Habit].self, from: data)
                self.habits = decoded
            } catch {
                print("Fehler beim Laden: \(error)")
            }
        }
    }
}
