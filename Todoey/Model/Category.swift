//
//  Category.swift
//  Todoey
//
//  Created by Patil, Vivek on 30/03/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    @objc dynamic var name: String = ""
    
    // Delcaring relationship
    let items = List<Item>()
}
