import SwiftUI

//G-44 UI Implementation

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

//Shopping list detail screen - Gio Lavilla

struct ShoppingListDetailsScreen: View {
    var listName: String
    @State private var items: [String] = ["Apple - $2", "Bread - $1.5"]
    @State private var showAddItemScreen = false

    var body: some View {
        List {
            ForEach(items, id: \.self) { item in
                Text(item)
            }
            .onDelete { indexSet in
                items.remove(atOffsets: indexSet)
            }
        }
        .navigationTitle(listName)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showAddItemScreen = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddItemScreen) {
            AddItemScreen(items: $items)
        }
    }
}

//Add shopping list - Gio Lavilla
struct AddShoppingListScreen: View {
    @Binding var shoppingLists: [String]
    @State private var newListName = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                TextField("List Name", text: $newListName)
            }
            .navigationTitle("New Shopping List")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if !newListName.isEmpty {
                            shoppingLists.append(newListName)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

//Add item - Gio Lavilla
struct AddItemScreen: View {
    @Binding var items: [String]
    @State private var itemName = ""
    @State private var itemPrice = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                TextField("Item Name", text: $itemName)
                TextField("Price ($)", text: $itemPrice)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("New Item")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if !itemName.isEmpty, let price = Double(itemPrice) {
                            items.append("\(itemName) - $\(price)")
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                }
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
