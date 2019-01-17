//
//  Standings.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 12/12/18.
//  Copyright © 2018 Valerii Petrychenko. All rights reserved.
//

import Foundation

class Standings: NSObject {

    let stage: String
    let type: String
    let group: String?
    let table: [Table]
    
    init?(json: [String: Any]) {
        guard let stage = json["stage"] as? String,
            let type = json["type"] as? String,
            let tables = json["table"] as? [[String : Any]]
            else { return nil }

        self.stage = stage
        self.type = type
        self.group = json["group"] as? String ?? nil

        var arrayTeams = [Table]()
        for table in tables {
            if let tableObject = Table(json: table) {
                arrayTeams.append(tableObject)
            }
        }
        self.table = arrayTeams
    }
}
