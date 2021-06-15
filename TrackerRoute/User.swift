//
//  User.swift
//  TrackerRoute
//
//  Created by Rayen on 15.06.2021.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var login = ""
    @objc dynamic var password = ""

    override static func primaryKey() -> String? {
            return "login"
        }
}
