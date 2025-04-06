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
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("globalTaxRate") private var globalTaxRate: Double = 0.0
    @State private var taxRateString: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Global Tax Rate")) {
                    TextField("Tax Rate (%)", text: $taxRateString)
                    
                    Text("Current Tax Rate: \(globalTaxRate, specifier: "%.2f")%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button("Save Tax Rate") {
                        if let newRate = Double(taxRateString) {
                            globalTaxRate = newRate
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .disabled(Double(taxRateString) == nil)
                }
                
                Section(header: Text("Information")) {
                    Text("The tax rate will be applied to all shopping lists unless a list has its own specific tax rate.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Tax Settings")
            .onAppear {
                taxRateString = String(format: "%.2f", globalTaxRate)
            }
        }
    }
}
