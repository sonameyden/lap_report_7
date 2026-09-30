import SwiftUI
import CoreData

struct EntryDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var entry: CraftEntry
    @State private var showingEdit = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if let data = entry.photo, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Text(entry.title ?? "Untitled")
                    .font(.largeTitle)
                    .bold()
                Text(entry.craftType ?? "")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                // M1: artisan on the detail screen
                if let artisan = entry.artisanName, !artisan.isEmpty {
                    Label(artisan, systemImage: "person")
                        .foregroundStyle(.secondary)
                }

                if let date = entry.date {
                    Text(date, style: .date)
                }

                if let notes = entry.notes, !notes.isEmpty {
                    Text(notes)
                        .padding(.top, 4)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // C4: favourite toggle
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    entry.isFavorite.toggle()
                    try? viewContext.save()
                } label: {
                    Image(systemName: entry.isFavorite ? "star.fill" : "star")
                        .foregroundStyle(entry.isFavorite ? .yellow : .accentColor)
                }
            }
            // M2: edit button
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") { showingEdit = true }
            }
        }
        .sheet(isPresented: $showingEdit) {
            AddEntryView(entry: entry)
                .environment(\.managedObjectContext, viewContext)
        }
    }
}
