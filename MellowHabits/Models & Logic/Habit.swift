import Foundation
import Observation

@Observable
class Habit: Identifiable, Codable {
    var id: UUID
    var title: String
    var time: String
    var currentPunches: Int
    var totalGoal: Int
    var punchDates: [Date]

    init(id: UUID = UUID(), title: String, time: String, currentPunches: Int, totalGoal: Int, punchDates: [Date] = []) {
        self.id = id
        self.title = title
        self.time = time
        self.currentPunches = currentPunches
        self.totalGoal = totalGoal
        self.punchDates = punchDates
    }

    var isCelebrated: Bool {
        guard totalGoal > 0 else { return false }
        return Double(currentPunches) / Double(totalGoal) >= 0.8
    }
}
