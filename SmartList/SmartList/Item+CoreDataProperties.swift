//
//  Item+CoreDataProperties.swift
//  SmartList
//
//  Created by Gio Lavilla on 05-04-2025.
//
//

import Foundation
import CoreData

extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var list: ShoppingList?

}

extension Item : Identifiable {

}
