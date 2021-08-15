//
//  Item2.swift
//  Simple Notes
//
//  Created by Naira Bassam on 11/08/2021.
//

import Foundation
import RealmSwift

class Item2: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category2.self, property: "items")
}
