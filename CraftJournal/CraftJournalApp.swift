//
//  CraftJournalApp.swift
//  CraftJournal
//
//  Created by iMac14 on 9/30/26.
//

import SwiftUI
import CoreData

@main
struct CraftJournalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
