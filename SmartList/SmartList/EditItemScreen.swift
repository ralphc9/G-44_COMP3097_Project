//
//  EditItemScreen.swift
//  SmartList
//
//  Created by Ralph Canlas on 05-04-2025.
//

import SwiftUI
import CoreData

struct EditItemScreen: View {
    @ObservedObject var item: Item
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var price: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Item Name", text: $name)
                TextField("Price", text: $price)

                Button("Save Changes") {
                    item.name = name
                    item.price = Double(price) ?? 0.0
                    saveContext()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(name.isEmpty || price.isEmpty)
            }
            .navigationTitle("Edit Item")
            .onAppear {
                name = item.name ?? ""
                price = String(format: "%.2f", item.price)
            }
        }
    }
    
    private func saveContext() {
        do { try viewContext.save() } catch { print("Save failed: \(error)") }
    }
}
