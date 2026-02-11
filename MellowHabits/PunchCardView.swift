//
//  PunchCardView.swift
//  MellowHabits
//
import SwiftUI

/// Eine wiederverwendbare Komponente zur Darstellung einer Habit-Stempelkarte.
struct PunchCardView: View {
    let title: String
    let time: String
    let currentPunches: Int
    let totalGoal: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Anzeige von Uhrzeit und Benachrichtigungsstatus
            HStack {
                Text(time)
                    .font(.caption)
                    .foregroundColor(.gray)
                Image(systemName: "bell.slash")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
            
            // Bezeichnung der Gewohnheit
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            // Horizontale Abfolge der Stempel-Elemente
            HStack(spacing: 8) {
                ForEach(1...totalGoal, id: \.self) { index in
                    Circle()
                        // Dynamische Farbfüllung basierend auf dem Fortschritt
                        .fill(index <= currentPunches ? Color.yellow : Color.gray.opacity(0.2))
                        .frame(width: 30, height: 30)
                        .overlay(
                            Text("\(index)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(index <= currentPunches ? .black : .gray)
                        )
                }
                
                // Indikator für weitere Details
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.leading, 4)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        // Subtiler Schatten zur visuellen Abhebung (Card-Design)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    // Vorschau mit Beispieldaten zur direkten visuellen Kontrolle
    PunchCardView(title: "Beispiel Habit", time: "10:00", currentPunches: 3, totalGoal: 5)
        .padding()
        .background(Color.gray.opacity(0.1))
}
#Preview {
    DashboardView()
}
