//
//  EditShoppingListScreen.swift
//  SmartList
//
//  Created by Ralph Canlas on 05-04-2025.
//

import SwiftUI
import CoreData

struct EditShoppingListScreen: View {
    @ObservedObject var list: ShoppingList
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
                
                Button("Save Changes") {
                    list.name = name
                    list.budget = Double(budget) ?? 0.0
                    list.taxRate = useGlobalTaxRate ? globalTaxRate : (Double(taxRate) ?? 0.0)
                    saveContext()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(name.isEmpty || budget.isEmpty || (!useGlobalTaxRate && taxRate.isEmpty))
            }
            .navigationTitle("Edit Shopping List")
            .onAppear {
                name = list.name ?? ""
                budget = String(format: "%.2f", list.budget)
                taxRate = String(format: "%.2f", list.taxRate)
                useGlobalTaxRate = list.taxRate == globalTaxRate
            }
        }
    }
    
    private func saveContext() {
        do { try viewContext.save() } catch { print("Save failed: \(error)") }
    }
}
