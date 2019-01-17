//
//  TeamDB.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 12/15/18.
//  Copyright © 2018 Valerii Petrychenko. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class TeamDB: Object {
    @objc dynamic var teamId: String = ""
    @objc dynamic var teamName: String = ""

    init(teamId: String, teamName: String) {
        super.init()

        self.teamId = teamId
        self.teamName = teamName
    }

    func toDictionary() -> Any {
        return ["Team Id": teamId, "Team Name": teamName] as Any
    }

    required init() {
        super.init()
        //fatalError("init() has not been implemented")
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
        //fatalError("init(realm:schema:) has not been implemented")
    }

    required init(value: Any, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
}
