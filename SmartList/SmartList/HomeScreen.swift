//
//  HomeScreen.swift
//  SmartList
//
//  Created by Gio Lavilla on 2025-03-12.
//

import SwiftUI
import CoreData

struct HomeScreen: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: ShoppingList.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingList.name, ascending: true)]
    ) var shoppingLists: FetchedResults<ShoppingList>
    
    @State private var showAddList = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(shoppingLists) { list in
                    NavigationLink(destination: ShoppingListDetailsScreen(list: list)) {
                        VStack(alignment: .leading) {
                            Text(list.name ?? "Untitled")
                                .font(.headline)
                            
                            // Updated ProgressBar with dynamic values
                            ProgressBar(value: calculateProgress(for: list))
                        }
                    }
                }
                .onDelete(perform: deleteList)
            }
            .navigationTitle("Shopping Lists")
            .toolbar {
                Button(action: { showAddList.toggle() }) {
                    Label("Add List", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showAddList) {
                AddShoppingListScreen()
            }
        }
    }
    
    private func deleteList(offsets: IndexSet) {
        for index in offsets {
            let list = shoppingLists[index]
            viewContext.delete(list)
        }
        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Save failed: \(error)")
        }
    }
    
    // Helper function to calculate progress
    private func calculateProgress(for list: ShoppingList) -> Double {
        // Calculate total cost from items
        let totalCost = list.itemsArray.reduce(0.0) { $0 + ($1.price ?? 0.0) }
        
        // Assume budget is a fixed value, or you could store this in Core Data
        let budget = list.budget ?? 0.0
        
        // Avoid division by zero
        guard budget > 0 else {
            return 0
        }
        
        return totalCost / budget
    }
}






