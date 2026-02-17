import SwiftUI

struct SettingsView: View {
    @Environment(HabitStore.self) private var store // Verbindung zum Store
    
    @State private var remindersEnabled = true
    @State private var soundEffectsEnabled = true
    @State private var showDeleteAlert = false // Für den Sicherheits-Check
    
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

                        // Sektion: Nutzender
                        VStack(alignment: .leading, spacing: 12) {
                            settingsLabel("Nutzender")
                            VStack(spacing: 0) {
                                settingsRow(icon: "person.crop.circle.fill", title: "Profil", value: "stefka_gel")
                                Divider().padding(.leading, 50)
                                toggleRow(icon: "bell.fill", title: "Erinnerungen", isOn: $remindersEnabled)
                            }
                            .background(Color.white)
                            .cornerRadius(20)
                        }
                        .padding(.horizontal, 25)

                        // Sektion: Erlebnis
                        VStack(alignment: .leading, spacing: 12) {
                            settingsLabel("Erlebnis")
                            VStack(spacing: 0) {
                                toggleRow(icon: "speaker.wave.2.fill", title: "Sound Effekte", isOn: $soundEffectsEnabled)
                                Divider().padding(.leading, 50)
                                settingsRow(icon: "archivebox.fill", title: "Archivierte Punchcards")
                            }
                            .background(Color.white)
                            .cornerRadius(20)
                        }
                        .padding(.horizontal, 25)

                        // Sektion: Rechtliches
                        VStack(alignment: .leading, spacing: 12) {
                            settingsLabel("Rechtliches")
                            VStack(spacing: 0) {
                                settingsRow(icon: "doc.text.fill", title: "Datenschutzerklärung")
                                Divider().padding(.leading, 50)
                                settingsRow(icon: "info.bubble.fill", title: "Impressum")
                            }
                            .background(Color.white)
                            .cornerRadius(20)
                        }
                        .padding(.horizontal, 25)

                        // Sektion: Info
                        VStack(alignment: .leading, spacing: 12) {
                            settingsLabel("Info")
                            VStack(spacing: 0) {
                                settingsRow(icon: "paintpalette.fill", title: "Design", value: "Mellow Mode")
                                Divider().padding(.leading, 50)
                                settingsRow(icon: "info.circle.fill", title: "Version", value: "1.0.4", showChevron: false)
                            }
                            .background(Color.white)
                            .cornerRadius(20)
                        }
                        .padding(.horizontal, 25)

                        // Sektion: Sicherheit
                        VStack(alignment: .leading, spacing: 12) {
                            settingsLabel("Sicherheit")
                            Button(action: {
                                showDeleteAlert = true // Zeigt den Bestätigungs-Dialog
                            }) {
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
                        }
                        .padding(.horizontal, 25)

                        Spacer(minLength: 150)
                    }
                }
            }
            // Der Alert, der beim Drücken auf Löschen erscheint
            .alert("Alles löschen?", isPresented: $showDeleteAlert) {
                Button("Abbrechen", role: .cancel) { }
                Button("Ja, alles löschen", role: .destructive) {
                    withAnimation {
                        store.clearAllData() // Ruft die Funktion im Store auf
                    }
                }
            } message: {
                Text("Bist du sicher? Alle deine Habits und Erfolge werden dauerhaft entfernt.")
            }
        }
    }

    // --- Komponenten (Unverändert im Look) ---

    private func settingsLabel(_ title: String) -> some View {
        Text(title.uppercased())
            .font(.system(size: 12, weight: .bold, design: .rounded))
            .foregroundColor(.secondary.opacity(0.6))
            .padding(.leading, 10)
    }

    private func toggleRow(icon: String, title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(mellowAccent)
                .frame(width: 35)
            Toggle(title, isOn: isOn)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .tint(mellowAccent)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 20)
    }

    private func settingsRow(icon: String, title: String, value: String? = nil, showChevron: Bool = true) -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(mellowAccent)
                .frame(width: 35)
            
            Text(title)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.black.opacity(0.7))
            
            Spacer()
            
            if let value = value {
                Text(value)
                    .font(.system(size: 15, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.gray.opacity(0.3))
            }
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 20)
    }
}

// MARK: - Preview
#Preview {
    let previewStore = HabitStore()
    // Optional: Hier ein paar Test-Habits hinzufügen, um zu sehen wie sie gelöscht werden
    return SettingsView()
        .environment(previewStore)
}
