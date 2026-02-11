import SwiftUI

/// Die Inhaltsansicht für das Dashboard (Tab: Übersicht)
struct DashboardView: View {
    var body: some View {
        ZStack {
            Color("MellowYellow").ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header-Bereich
                    HStack {
                        Text("Feiere deinen nächsten Schritt!")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 40, height: 40)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)

                    // Filter-Button
                    Button(action: {}) {
                        Label("Filter", systemImage: "line.3.horizontal.decrease")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(20)
                    }
                    .padding(.horizontal)

                    // Liste der Gewohnheiten
                    VStack(spacing: 16) {
                        PunchCardView(title: "Morgenroutine", time: "08:00", currentPunches: 3, totalGoal: 7)
                        PunchCardView(title: "Recipe Research", time: "18:30", currentPunches: 1, totalGoal: 5)
                    }
                    .padding(.horizontal)
                }
            }
            
            // Schwebender Plus-Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "plus")
                            .font(.title.bold())
                            .foregroundColor(.black)
                            .frame(width: 60, height: 60)
                            .background(Color.yellow)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

#Preview {
    DashboardView()
}
