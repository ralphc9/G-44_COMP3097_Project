//
//  AddShoppingListScreen.swift
//  SmartList
//
//  Created by Gio Lavilla on 2025-03-12.
//

import SwiftUI
import CoreData

struct AddShoppingListScreen: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("List Name", text: $name)
                Button("Save") {
                    let newList = ShoppingList(context: viewContext)
                    newList.name = name
                    saveContext()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("New Shopping List")
        }
    }
    
    private func saveContext() {
        do { try viewContext.save() } catch { print("Save failed: \(error)") }
    }
}


