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

                Button("Add Item") {
                    let newItem = NSEntityDescription.insertNewObject(forEntityName: "Item", into: viewContext) as! Item
                    newItem.name = name
                    newItem.price = Double(price) ?? 0.0
                    newItem.list = list
                    saveContext()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(name.isEmpty || price.isEmpty)
            }
            .navigationTitle("Add Item")
        }
    }
    
    private func saveContext() {
        do { try viewContext.save() } catch { print("Save failed: \(error)") }
    }
}
