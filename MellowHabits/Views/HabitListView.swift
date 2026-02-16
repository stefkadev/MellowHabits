import SwiftUI

struct HabitListView: View { // Name angepasst (ohne 's')
    @Environment(HabitStore.self) private var store
    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color("MellowYellow").ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        // Header-Info für den Vibe
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Deine Punchcards")
                                .font(.system(size: 32, weight: .black, design: .rounded))
                            Text("Level deinen Charakter durch Beständigkeit.")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 20)
                        
                        // Die Karten
                        ForEach(store.habits) { habit in
                            PunchCardView(habit: habit)
                                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                        }
                    }
                    .padding()
                    .padding(.bottom, 100)
                }
                
                // Plus-Button im Mellow-Stil (Schwarz wie im Dashboard)
                floatingAddButton
            }
            .sheet(isPresented: $showingAddSheet) {
                AddHabitView()
            }
        }
    }
    
    private var floatingAddButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: { showingAddSheet = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 64, height: 64)
                        .background(Color.black)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
                .padding(30)
            }
        }
    }
}

// MARK: - Preview (Nach unserer neuen Regel)
#Preview {
    let previewStore = HabitStore()
    if previewStore.habits.isEmpty {
        previewStore.addHabit(title: "Die Gemeinde pflegen", time: "Täglich", goal: 5)
        previewStore.addHabit(title: "Looten und Leveln", time: "Abends", goal: 10)
    }
    
    return HabitListView()
        .environment(previewStore)
}
