import SwiftUI

@main
struct MellowHabitsApp: App {
    @State private var habitStore = HabitStore()

    var body: some Scene { 
        WindowGroup {
            ContentView()
                .environment(habitStore)
        }
    }
}
