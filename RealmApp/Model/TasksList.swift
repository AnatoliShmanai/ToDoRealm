//
//  TasksList.swift
//  RealmApp
//
//  Created by shmanai on 10/13/20.
//  Copyright © 2020 Anatoli Shmanai. All rights reserved.
//

import RealmSwift

class TasksList: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    let tasks = List<Task>()
}
