import Foundation
import Observation

@Observable
class Habit: Identifiable, Codable {

    var id: UUID
    var title: String
    var time: String
    var currentPunches: Int
    var totalGoal: Int
    
    init(id: UUID = UUID(), title: String, time: String, currentPunches: Int, totalGoal: Int) {
        self.id = id
        self.title = title
        self.time = time
        self.currentPunches = currentPunches
        self.totalGoal = totalGoal
    }

    var isCelebrated: Bool {
        guard totalGoal > 0 else { return false }
        return Double(currentPunches) / Double(totalGoal) >= 0.8
    }
}
