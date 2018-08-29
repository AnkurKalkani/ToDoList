//
//  Category.swift
//  ToDoList
//
//  Created by Sierra on 27/08/18.
//  Copyright © 2018 Sierra. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    var items = List<Item>()
}
