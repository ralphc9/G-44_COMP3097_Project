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
    @AppStorage("globalTaxRate") private var globalTaxRate: Double = 0.0
    @State private var name: String = ""
    @State private var budget: String = ""
    @State private var taxRate: String = ""
    @State private var useGlobalTaxRate: Bool = true
    
    var body: some View {
        NavigationView {
            Form {
                TextField("List Name", text: $name)
                
                TextField("Budget", text: $budget)
                
                Section(header: Text("Tax Settings")) {
                    Toggle("Use Global Tax Rate", isOn: $useGlobalTaxRate)
                    
                    if !useGlobalTaxRate {
                        TextField("Tax Rate (%)", text: $taxRate)
                    } else {
                        Text("Global Tax Rate: \(globalTaxRate, specifier: "%.2f")%")
                            .foregroundColor(.secondary)
                    }
                }
                
                Button("Save") {
                    let newList = NSEntityDescription.insertNewObject(forEntityName: "ShoppingList", into: viewContext) as! ShoppingList
                    newList.name = name
                    newList.budget = Double(budget) ?? 0.0
                    newList.taxRate = useGlobalTaxRate ? globalTaxRate : (Double(taxRate) ?? 0.0)
                    saveContext()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(name.isEmpty || budget.isEmpty || (!useGlobalTaxRate && taxRate.isEmpty))
            }
            .navigationTitle("New Shopping List")
            .onAppear {
                taxRate = String(format: "%.2f", globalTaxRate)
            }
        }
    }
    
    private func saveContext() {
        do { try viewContext.save() } catch { print("Save failed: \(error)") }
    }
}
