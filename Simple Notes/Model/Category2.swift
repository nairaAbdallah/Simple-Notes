//
//  Category2.swift
//  Simple Notes
//
//  Created by Naira Bassam on 11/08/2021.
//

import Foundation
import RealmSwift

class Category2: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item2>()
}
