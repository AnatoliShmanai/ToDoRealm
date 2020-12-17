//
//  Task.swift
//  RealmApp
//
//  Created by shmanai on 10/13/20.
//  Copyright © 2020 Anatoli Shmanai. All rights reserved.
//

import RealmSwift

class Task: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var note = ""
    @objc dynamic var date = Date()
    @objc dynamic var isComplete = false
}
