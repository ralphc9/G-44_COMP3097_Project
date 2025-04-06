//
//  CoreDataExtentions.swift
//  SmartList
//
//  Created by Ralph Canlas on 05-04-2025.
//

import Foundation
import CoreData

// MARK: - ShoppingList Extensions
extension ShoppingList {
    var itemsArray: [Item] {
        let set = items as? Set<Item> ?? []
        return set.sorted { $0.name ?? "" < $1.name ?? "" }
    }
    
    // Calculate total cost including tax
    var totalCost: Double {
        let subtotal = itemsArray.reduce(0.0) { $0 + $1.price }
        return subtotal * (1 + (taxRate / 100.0))
    }
}
