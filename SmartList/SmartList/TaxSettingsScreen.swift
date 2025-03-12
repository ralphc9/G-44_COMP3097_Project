//
//  TaxSettingsScreen.swift
//  SmartList
//
//  Created by Gio Lavilla on 2025-03-12.
//

import SwiftUI
import CoreData

struct TaxSettingsScreen: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]
    ) var categories: FetchedResults<Category>
    
    @State private var showAddCategory = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(categories) { category in
                    HStack {
                        Text(category.name ?? "Unnamed Category")
                        Spacer()
                        Text("\(category.taxRate, specifier: "%.2f")%")
                    }
                }
                .onDelete(perform: deleteCategory)
            }
            .navigationTitle("Tax Settings")
            .toolbar {
                Button(action: { showAddCategory.toggle() }) {
                    Label("Add Category", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showAddCategory) {
                AddCategoryScreen()
            }
        }
    }
    
    private func deleteCategory(offsets: IndexSet) {
        for index in offsets {
            let category = categories[index]
            viewContext.delete(category)
        }
        saveContext()
    }
    
    private func saveContext() {
        do { try viewContext.save() } catch { print("Save failed: \(error)") }
    }
}

