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
    @State private var showEditList = false
    @State private var selectedItem: Item? = nil
    
    var body: some View {
        VStack {
            // Budget progress bar
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Budget: $\(list.budget, specifier: "%.2f")")
                    Spacer()
                    Text("Total: $\(list.totalCost, specifier: "%.2f")")
                        .fontWeight(.bold)
                }
                
                ProgressBar(value: calculateProgress())
                
                Text("Tax Rate: \(list.taxRate, specifier: "%.2f")%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            
            List {
                ForEach(list.itemsArray, id: \.self) { item in
                    Button(action: {
                        selectedItem = item
                    }) {
                        HStack {
                            Text(item.name ?? "Unknown Item")
                            Spacer()
                            Text("$\(item.price, specifier: "%.2f")")
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle(list.name ?? "Shopping List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddItem.toggle() }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showEditList.toggle() }) {
                        Label("Edit List", systemImage: "pencil")
                    }
                }
            }
            .sheet(isPresented: $showAddItem) {
                AddItemScreen(list: list)
            }
            .sheet(isPresented: $showEditList) {
                EditShoppingListScreen(list: list)
            }
            .sheet(item: $selectedItem) { item in
                EditItemScreen(item: item)
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            let item = list.itemsArray[index]
            viewContext.delete(item)
        }
        saveContext()
    }
    
    private func saveContext() {
        do { try viewContext.save() } catch { print("Save failed: \(error)") }
    }
    
    private func calculateProgress() -> Double {
        // Calculate total cost from items
        let totalCost = list.totalCost
        
        // Avoid division by zero
        guard list.budget > 0 else {
            return 0
        }
        
        return min(totalCost / list.budget, 1.0)
    }
}
