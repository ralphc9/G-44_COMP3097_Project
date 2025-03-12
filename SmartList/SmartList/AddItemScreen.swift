//
//  AddItemScreen.swift
//  SmartList
//
//  Created by Gio Lavilla on 2025-03-12.
//

import SwiftUI
import CoreData

struct AddItemScreen: View {
    @ObservedObject var list: ShoppingList
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var price: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Item Name", text: $name)
                TextField("Price", text: $price)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Add Item") {
                    let newItem = Item(context: viewContext)
                    newItem.name = name
                    newItem.price = Double(price) ?? 0.0
                    list.addToItems(newItem)
                    saveContext()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Add Item")
        }
    }
    
    private func saveContext() {
        do { try viewContext.save() } catch { print("Save failed: \(error)") }
    }
}


