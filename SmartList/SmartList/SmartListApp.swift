//
//  SmartListApp.swift
//  SmartList
//
//  Created by Ralph Canlas on 2025-03-12.
//

import SwiftUI

@main
struct SmartListApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environment(\.managedObjectContext, persistenceController.context)
        }
    }
}

