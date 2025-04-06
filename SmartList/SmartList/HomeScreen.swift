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
    @State private var showTaxSettings = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(shoppingLists) { list in
                    NavigationLink(destination: ShoppingListDetailsScreen(list: list)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(list.name ?? "Untitled")
                                .font(.headline)
                            
                            HStack {
                                Text("Budget: $\(list.budget, specifier: "%.2f")")
                                    .font(.caption)
                                Spacer()
                                Text("$\(list.totalCost, specifier: "%.2f")")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                            
                            // Updated ProgressBar with dynamic values
                            ProgressBar(value: calculateProgress(for: list))
                        }
                    }
                }
                .onDelete(perform: deleteList)
            }
            .navigationTitle("Shopping Lists")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddList.toggle() }) {
                        Label("Add List", systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showTaxSettings.toggle() }) {
                        Label("Tax Settings", systemImage: "percent")
                    }
                }
            }
            .sheet(isPresented: $showAddList) {
                AddShoppingListScreen()
            }
            .sheet(isPresented: $showTaxSettings) {
                TaxSettingsScreen()
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
        let totalCost = list.totalCost
        
        // Avoid division by zero
        guard list.budget > 0 else {
            return 0
        }
        
        return min(totalCost / list.budget, 1.0)
    }
}
