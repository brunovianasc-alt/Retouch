import PhotosUI
import SwiftUI

struct ContentView: View {
    @StateObject private var editor = EditorViewModel()
    @State private var pickerItem: PhotosPickerItem?
    @State private var saveMessage: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Group {
                    if let image = editor.renderedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .accessibilityLabel("Imagem em edição")
                    } else {
                        ContentUnavailableView(
                            "Escolha uma foto",
                            systemImage: "photo.on.rectangle.angled",
                            description: Text("Comece importando uma imagem da sua biblioteca.")
                        )
                    }
                }
                .frame(maxHeight: 420)

                PhotosPicker("Importar foto", selection: $pickerItem, matching: .images)
                    .buttonStyle(.borderedProminent)

                if editor.originalImage != nil {
                    Picker("Estilo", selection: $editor.style) {
                        ForEach(EditStyle.allCases) { style in
                            Text(style.title).tag(style)
                        }
                    }
                    .pickerStyle(.segmented)

                    VStack(alignment: .leading) {
                        Text("Intensidade: \(Int(editor.intensity * 100))%")
                        Slider(value: $editor.intensity, in: 0...1)
                    }

                    Button("Salvar em Fotos", systemImage: "square.and.arrow.down") {
                        guard let image = editor.renderedImage else { return }
                        PhotoLibrarySaver.save(image) { result in
                            saveMessage = result
                        }
                    }
                    .buttonStyle(.bordered)
                }

                Spacer(minLength: 0)
            }
            .padding()
            .navigationTitle("Retouch")
            .onChange(of: pickerItem) { _, item in
                Task { await editor.load(item) }
            }
            .alert("Retouch", isPresented: Binding(
                get: { saveMessage != nil },
                set: { if !$0 { saveMessage = nil } }
            )) {
                Button("OK", role: .cancel) { saveMessage = nil }
            } message: {
                Text(saveMessage ?? "")
            }
        }
    }
}

#Preview {
    ContentView()
}
