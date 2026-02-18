import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var opacity = 0.5
    @State private var size = 0.8
    
    // Design-Farben
    private let deepGold = Color(red: 0.75, green: 0.55, blue: 0.10)
    private let cozyBg = Color(red: 0.96, green: 0.93, blue: 0.88)
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                cozyBg.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 80))
                        .foregroundColor(deepGold)
                        .scaleEffect(size)
                        .opacity(opacity)
                    
                    VStack(spacing: 8) {
                        Text("Mellow Habits")
                            .font(.system(size: 42, weight: .heavy, design: .rounded))
                            .foregroundColor(.black.opacity(0.8))
                        
                        Text("Done is better than perfect!")
                            .font(.system(size: 16, weight: .medium, design: .serif))
                            .italic()
                            .foregroundColor(deepGold.opacity(0.7))
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                }
            }
            .onAppear {
                // Sanfte Einblende-Animation
                withAnimation(.easeIn(duration: 1.2)) {
                    self.size = 1.0
                    self.opacity = 1.0
                }
                
                // Wechsel zur ContentView nach 2.5 Sekunden
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    let store = HabitStore()
    return SplashScreenView()
        .environment(store)
}
