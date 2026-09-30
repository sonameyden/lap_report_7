import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CraftEntry.date, ascending: false)],
        animation: .default
    )
    private var entries: FetchedResults<CraftEntry>

    @State private var showingAddEntry = false
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            Group {
                if entries.isEmpty {
                    if searchText.isEmpty {
                        // M3: friendly empty state
                        ContentUnavailableView(
                            "No Entries Yet",
                            systemImage: "book.closed",
                            description: Text("Tap + to add your first craft.")
                        )
                    } else {
                        // C2: nothing matched the search
                        ContentUnavailableView.search(text: searchText)
                    }
                } else {
                    List {
                        // M3: entry count
                        Section {
                            ForEach(entries) { entry in
                                NavigationLink {
                                    EntryDetailView(entry: entry)
                                } label: {
                                    EntryRow(entry: entry)
                                }
                            }
                            .onDelete(perform: deleteEntries)
                        } header: {
                            Text(entries.count == 1 ? "1 entry" : "\(entries.count) entries")
                        }
                    }
                }
            }
            .navigationTitle("Craft Journal")
            .searchable(text: $searchText, prompt: "Search by title")   // C2
            .onChange(of: searchText) { _, newValue in
                entries.nsPredicate = newValue.isEmpty
                    ? nil
                    : NSPredicate(format: "title CONTAINS[cd] %@", newValue)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddEntry = true
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddEntry) {
                AddEntryView()
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }

    private func deleteEntries(offsets: IndexSet) {
        offsets.map { entries[$0] }.forEach(viewContext.delete)
        do {
            try viewContext.save()
        } catch {
            print("Could not delete: \(error)")
        }
    }
}

struct EntryRow: View {
    @ObservedObject var entry: CraftEntry

    var body: some View {
        HStack {
            if let data = entry.photo, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Image(systemName: "photo")
                    .frame(width: 60, height: 60)
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading) {
                Text(entry.title ?? "Untitled")
                    .font(.headline)
                Text(entry.craftType ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                // M1: artisan in the row
                if let artisan = entry.artisanName, !artisan.isEmpty {
                    Text("By \(artisan)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            // C4: star for favourites
            if entry.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(
            \.managedObjectContext,
            PersistenceController.preview.container.viewContext
        )
}
