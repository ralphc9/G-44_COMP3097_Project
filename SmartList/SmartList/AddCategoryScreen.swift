//
//  AddCategoryScreen.swift
//  SmartList
//
//  Created by Ralph Canlas on 2025-03-12.
//

import SwiftUI
import CoreData

struct AddCategoryScreen: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State private var categoryName: String = ""
    @State private var taxRate: String = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Category Name", text: $categoryName)
                TextField("Tax Rate (%)", text: $taxRate)
                    .keyboardType(.decimalPad)
                
                Button("Save") {
                    addCategory()
                }
                .disabled(categoryName.isEmpty || taxRate.isEmpty)
            }
            .navigationTitle("New Tax Category")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    private func addCategory() {
        let newCategory = Category(context: viewContext)
        newCategory.name = categoryName
        newCategory.taxRate = Double(taxRate) ?? 0.0
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Failed to save category: \(error.localizedDescription)")
        }
    }
}


