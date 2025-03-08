import SwiftUI

@main
struct SmartListApp: App {
    var body: some Scene {
        WindowGroup {
            HomeScreen()
        }
    }
}

//- HOME SCREEN - Ralph Canlas
struct HomeScreen: View {
    @State private var shoppingLists: [String] = ["Grocery List", "Household Items"]
    @State private var showAddListScreen = false

    var body: some View {
        NavigationView {
            List {
                ForEach(shoppingLists, id: \.self) { list in
                    NavigationLink(destination: ShoppingListDetailsScreen(listName: list)) {
                        Text(list)
                    }
                }
                .onDelete { indexSet in
                    shoppingLists.remove(atOffsets: indexSet)
                }
            }
            .navigationTitle("SmartList")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddListScreen = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddListScreen) {
                AddShoppingListScreen(shoppingLists: $shoppingLists)
            }
        }
    }
}


//- TAX CONFIGURATION SCREEN - Ralph Canlas
struct TaxConfigScreen: View {
    @State private var taxCategories: [String: Double] = ["Food": 5.0, "Medication": 0.0]
    @State private var showAddTaxScreen = false

    var body: some View {
        NavigationView {
            List {
                ForEach(taxCategories.sorted(by: { $0.key < $1.key }), id: \.key) { category, rate in
                    HStack {
                        Text(category)
                        Spacer()
                        Text("\(rate, specifier: "%.1f")%")
                    }
                }
            }
            .navigationTitle("Tax & Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddTaxScreen = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddTaxScreen) {
                AddTaxCategoryScreen(taxCategories: $taxCategories)
            }
        }
    }
}

//- ADD TAX CATEGORY SCREEN - Ralph Canlas
struct AddTaxCategoryScreen: View {
    @Binding var taxCategories: [String: Double]
    @State private var categoryName = ""
    @State private var taxRate = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                TextField("Category Name", text: $categoryName)
                TextField("Tax Rate (%)", text: $taxRate)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("New Tax Category")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let rate = Double(taxRate), !categoryName.isEmpty {
                            taxCategories[categoryName] = rate
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
