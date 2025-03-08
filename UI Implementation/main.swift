Import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            HomeScreen()
        }
    }
}

struct HomeScreen: View {
    @State private var shoppingLists = ["Grocery List", "Household Items", "Electronics"]
    
    var body: some View {
        VStack {
            List {
                ForEach(shoppingLists, id: \..self) { list in
                    NavigationLink(destination: ShoppingListDetailsScreen(listName: list)) {
                        Text(list)
                    }
                }
                .onDelete { indexSet in
                    shoppingLists.remove(atOffsets: indexSet)
                }
            }
            Button("Add New List") {
                shoppingLists.append("New List")
            }
            .padding()
        }
        .navigationTitle("SmartShop")
        .toolbar {
            NavigationLink(destination: TaxSettingsScreen()) {
                Image(systemName: "gear")
            }
        }
    }
}

struct ShoppingListDetailsScreen: View {
    var listName: String
    @State private var items = ["Apple - $2", "Bread - $1.5", "Soap - $3"]
    
    var body: some View {
        VStack {
            List {
                ForEach(items, id: \..self) { item in
                    Text(item)
                }
                .onDelete { indexSet in
                    items.remove(atOffsets: indexSet)
                }
            }
            Button("Add Item") {
                items.append("New Item - $0")
            }
            .padding()
        }
        .navigationTitle(listName)
    }
}

struct TaxSettingsScreen: View {
    @State private var taxCategories = ["Food - 5%", "Medication - 0%", "Cleaning - 13%"]
    
    var body: some View {
        VStack {
            List {
                ForEach(taxCategories, id: \..self) { category in
                    Text(category)
                }
                .onDelete { indexSet in
                    taxCategories.remove(atOffsets: indexSet)
                }
            }
            Button("Add New Category") {
                taxCategories.append("New Category - 0%")
            }
            .padding()
        }
        .navigationTitle("Tax & Settings")
    }
}

@main
struct SmartShopApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
