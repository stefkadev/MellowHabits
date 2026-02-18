import SwiftUI

struct SettingsView: View {
    @Environment(HabitStore.self) private var store
    
    @State private var remindersEnabled = true
    @State private var soundEffectsEnabled = true
    @State private var showDeleteAlert = false
    
    // Cozy Palette
    private let mellowAccent = Color(red: 0.98, green: 0.82, blue: 0.25)
    private let cozyBg = Color(red: 0.96, green: 0.93, blue: 0.88)
    private let deepGold = Color(red: 0.75, green: 0.55, blue: 0.10)

    var body: some View {
        NavigationStack {
            ZStack {
                cozyBg.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        // Header
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Einstellungen")
                                .font(.system(size: 40, weight: .heavy, design: .rounded))
                                .foregroundColor(Color.black.opacity(0.8))
                        }
                        .padding(.horizontal, 25)
                        .padding(.top, 30)

                        // Sektion: Konto (Neu & Vorbereitet)
                        VStack(alignment: .leading, spacing: 12) {
                            settingsLabel("Konto")
                            VStack(spacing: 0) {
                                settingsRow(icon: "person.crop.circle.fill", title: "Profil", value: "stefka_gel")
                                Divider().padding(.leading, 60)
                                settingsRow(icon: "icloud.fill", title: "Speicherort", value: "Lokal (Gerät)", showChevron: false)
                            }
                            .background(Color.white)
                            .cornerRadius(20)
                        }
                        .padding(.horizontal, 25)

                        // Sektion: Mitteilungen & Töne
                        VStack(alignment: .leading, spacing: 12) {
                            settingsLabel("Mitteilungen")
                            VStack(spacing: 0) {
                                toggleRow(icon: "bell.fill", title: "Erinnerungen", isOn: $remindersEnabled)
                                Divider().padding(.leading, 60)
                                toggleRow(icon: "speaker.wave.2.fill", title: "Sound Effekte", isOn: $soundEffectsEnabled)
                            }
                            .background(Color.white)
                            .cornerRadius(20)
                        }
                        .padding(.horizontal, 25)

                        // Sektion: Support & Feedback
                        VStack(alignment: .leading, spacing: 12) {
                            settingsLabel("Hilfe")
                            VStack(spacing: 0) {
                                settingsRow(icon: "envelope.fill", title: "Feedback senden")
                                Divider().padding(.leading, 60)
                                settingsRow(icon: "star.fill", title: "App bewerten")
                            }
                            .background(Color.white)
                            .cornerRadius(20)
                        }
                        .padding(.horizontal, 25)

                        // Sektion: Rechtliches & Info
                        VStack(alignment: .leading, spacing: 12) {
                            settingsLabel("Info")
                            VStack(spacing: 0) {
                                settingsRow(icon: "paintpalette.fill", title: "Design", value: "Mellow Mode")
                                Divider().padding(.leading, 60)
                                settingsRow(icon: "info.circle.fill", title: "Version", value: "1.0.4", showChevron: false)
                            }
                            .background(Color.white)
                            .cornerRadius(20)
                        }
                        .padding(.horizontal, 25)

                        // Sektion: Gefahrzone & Logout
                        VStack(alignment: .center, spacing: 16) {
                            Button(action: { showDeleteAlert = true }) {
                                HStack {
                                    Image(systemName: "trash.fill")
                                    Text("Alle Daten zurücksetzen")
                                }
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.red.opacity(0.8))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                            }
                            
                            Button(action: { /* Späterer Logout-Code */ }) {
                                Text("Abmelden")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(.black.opacity(0.3))
                                    .padding(.top, 10)
                            }
                        }
                        .padding(.horizontal, 25)

                        Spacer(minLength: 150)
                    }
                }
            }
            .alert("Alles löschen?", isPresented: $showDeleteAlert) {
                Button("Abbrechen", role: .cancel) { }
                Button("Ja, alles löschen", role: .destructive) {
                    store.clearAllData()
                }
            } message: {
                Text("Bist du sicher? Alle deine Habits und Erfolge werden dauerhaft entfernt.")
            }
        }
    }

    // --- Komponenten ---

    private func settingsLabel(_ title: String) -> some View {
        Text(title.uppercased())
            .font(.system(size: 12, weight: .bold, design: .rounded))
            .foregroundColor(.black.opacity(0.4))
            .padding(.leading, 10)
    }

    private func toggleRow(icon: String, title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(deepGold)
                .frame(width: 35)
            Toggle(title, isOn: isOn)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.black.opacity(0.8))
                .tint(mellowAccent)
        }
        .padding(.vertical, 14).padding(.horizontal, 20)
    }

    private func settingsRow(icon: String, title: String, value: String? = nil, showChevron: Bool = true) -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(deepGold)
                .frame(width: 35)
            Text(title)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.black.opacity(0.8))
            Spacer()
            if let value = value {
                Text(value)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(deepGold)
            }
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black.opacity(0.2))
            }
        }
        .padding(.vertical, 18).padding(.horizontal, 20)
    }
}

// MARK: - Preview
#Preview {
    let previewStore = HabitStore()
    return SettingsView()
        .environment(previewStore)
}
