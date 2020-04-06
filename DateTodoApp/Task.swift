//
//  Task.swift
//  DateTodoApp
//
//  Created by Shota Ishii on 2020/04/06.
//  Copyright © 2020 is. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var memo = ""
    @objc dynamic var date = ""
    @objc dynamic var time = ""
    @objc dynamic var hour = 0
    @objc dynamic var timer = Date()
    override static func primaryKey() -> String? {
        return "id"
    }
}
