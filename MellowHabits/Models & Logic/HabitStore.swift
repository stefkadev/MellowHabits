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
    
    // MARK: - Beispieldaten Logik (Lurch-Edition)
    func addSampleData() {
        // --- DASHBOARD-DATEN (totalGoal = 1) ---
        addHabit(title: "Pfanne im Wald suchen", time: "Morgens", icon: "frying.pan", goal: 1)
        addHabit(title: "Ein freundliches 'Hering!' rufen", time: "Mittags", icon: "mouth", goal: 1)
        addHabit(title: "Kohle? KOHLE!", time: "Abends", icon: "bitcoinsign.circle", goal: 1)
        
        // --- PUNCHCARD-DATEN (totalGoal = 10) ---
        addHabit(title: "Lurche grüßen", time: "Täglich", icon: "lizard.fill", goal: 10)
        addHabit(title: "Im Inventar kramen", time: "3x Woche", icon: "archivebox.fill", goal: 10)
        addHabit(title: "Schon GEZahlt?", time: "Unregelmäßig", icon: "tv", goal: 10)
        
        // Initial-Stempel für die Statistik
        if let lurchHabit = habits.first(where: { $0.title == "Lurche grüßen" }) {
            for _ in 0..<7 {
                lurchHabit.currentPunches += 1
                lurchHabit.punchDates.append(Date())
            }
        }
        save()
    }
    
    // MARK: - Hauptfunktionen
    func addHabit(title: String, time: String, icon: String = "star.fill", goal: Int) {
        if !habits.contains(where: { $0.title == title }) {
            let newHabit = Habit(
                title: title,
                time: time,
                icon: icon,
                currentPunches: 0,
                totalGoal: goal,
                punchDates: []
            )
            habits.append(newHabit)
        }
    }
    
    // Für die Punchcards (HabitListView)
    func addPunch(to habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            if habits[index].currentPunches < habits[index].totalGoal {
                habits[index].currentPunches += 1
                habits[index].punchDates.append(Date())
                save()
            }
        }
    }
    
    // Für die Merkliste (DashboardView)
    func toggleHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            if habits[index].currentPunches == 0 {
                habits[index].currentPunches = 1
                habits[index].punchDates.append(Date())
            } else {
                habits[index].currentPunches = 0
                // Optional: Den letzten Punch-Eintrag entfernen
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
    
    // MARK: - Persistence
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
