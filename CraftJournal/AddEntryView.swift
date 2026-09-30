import SwiftUI
import CoreData
import PhotosUI

struct AddEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    // M2: nil = creating a new entry, non-nil = editing this entry
    var entry: CraftEntry?

    @State private var title: String
    @State private var craftType: String
    @State private var artisanName: String
    @State private var notes: String
    @State private var image: UIImage?
    @State private var showingCamera = false
    @State private var selectedItem: PhotosPickerItem?

    init(entry: CraftEntry? = nil) {
        self.entry = entry
        _title = State(initialValue: entry?.title ?? "")
        _craftType = State(initialValue: entry?.craftType ?? crafts[0])
        _artisanName = State(initialValue: entry?.artisanName ?? "")
        _notes = State(initialValue: entry?.notes ?? "")
        if let data = entry?.photo {
            _image = State(initialValue: UIImage(data: data))
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                Picker("Craft", selection: $craftType) {
                    ForEach(crafts, id: \.self) { craft in
                        Text(craft)
                    }
                }
                TextField("Artisan name", text: $artisanName)   // M1
                Section("Photo") {
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 250)
                    }
                    Button("Take Photo") {
                        showingCamera = true
                    }
                    .disabled(!UIImagePickerController.isSourceTypeAvailable(.camera))

                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Text("Choose from Library")
                    }
                }
                TextField("Notes", text: $notes, axis: .vertical)
                    .lineLimit(3...6)
            }
            .navigationTitle(entry == nil ? "New Entry" : "Edit Entry")
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        image = uiImage
                    }
                }
            }
            .fullScreenCover(isPresented: $showingCamera) {
                CameraView(image: $image)
                    .ignoresSafeArea()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveEntry() }
                        .disabled(title.isEmpty)
                }
            }
        }
    }

    private func saveEntry() {
        // M2: reuse the existing object when editing, create one only when adding
        let target: CraftEntry
        if let entry {
            target = entry
        } else {
            target = CraftEntry(context: viewContext)
            target.id = UUID()
            target.date = Date()
        }
        target.title = title
        target.craftType = craftType
        target.artisanName = artisanName
        target.notes = notes
        target.photo = image?.jpegData(compressionQuality: 0.7)
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Could not save: \(error)")
        }
    }
}
