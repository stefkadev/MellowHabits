import SwiftUI

struct StatisticsView: View {
    var body: some View {
        ZStack {
            // Hintergrundfarbe für ein einheitliches Design
            Color("MellowYellow").ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Deine Erfolge")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .padding(.top, 20)
                
                Spacer()
                
                // Platzhalter für die 80%-Logik
                Image(systemName: "trophy.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)
                
                Text("Hier erscheinen deine abgeschlossenen Karten, sobald du 80% erreicht hast.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .foregroundColor(.gray)
                
                Spacer()
            }
        }
    }
}

#Preview {
    StatisticsView()
}
