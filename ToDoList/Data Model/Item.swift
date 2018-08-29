//
//  Item.swift
//  ToDoList
//
//  Created by Sierra on 27/08/18.
//  Copyright © 2018 Sierra. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentcategory = LinkingObjects.init(fromType: Category.self, property: "items")
}

