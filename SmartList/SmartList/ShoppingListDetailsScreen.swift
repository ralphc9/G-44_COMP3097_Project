//
//  ShoppingListDetailsScreen.swift
//  SmartList
//
//  Created by Ralph Canlas on 2025-03-12.
//

import SwiftUI
import CoreData

struct ShoppingListDetailsScreen: View {
    @ObservedObject var list: ShoppingList
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showAddItem = false
    
    var body: some View {
        VStack {
            List {
                ForEach(list.itemsArray, id: \.self) { item in
                    HStack {
                        Text(item.name ?? "Unknown Item")
                        Spacer()
                        Text("$\(item.price, specifier: "%.2f")")
                    }
                }
            }
            .navigationTitle(list.name ?? "Shopping List")
            .toolbar {
                Button(action: { showAddItem.toggle() }) {
                    Label("Add Item", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showAddItem) {
                AddItemScreen(list: list)
            }
        }
    }
}

// 🔹 FIX: Convert Core Data relationship to an array
extension ShoppingList {
    var itemsArray: [Item] {
        let set = items as? Set<Item> ?? []
        return set.sorted { $0.name ?? "" < $1.name ?? "" }
    }
}





