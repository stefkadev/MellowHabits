import SwiftUI

struct HabitsListView: View {
    @Environment(HabitStore.self) private var store
    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color("MellowYellow").ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(store.habits) { habit in
                            PunchCardView(habit: habit)
                        }
                    }
                    .padding()
                }
                .navigationTitle("Gewohnheiten")
                
                // Der Plus-Button ist hier auf der Interaktions-Seite
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showingAddSheet = true }) {
                            Image(systemName: "plus")
                                .font(.title.bold())
                                .foregroundColor(.black)
                                .frame(width: 60, height: 60)
                                .background(Color.yellow)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding()
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                // Hier fügen wir später das Eingabeformular ein
                Text("Neuen Habit hinzufügen")
            }
        }
    }
}
