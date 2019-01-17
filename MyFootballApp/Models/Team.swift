//
//  Team.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 12/12/18.
//  Copyright © 2018 Valerii Petrychenko. All rights reserved.
//

import Foundation
import UIKit

class Team {
    let id: Int
    let areaName: String
    let name: String
    let crestUrl: String?
    let address: String?
    let phone: String?
    let website: String?
    let email: String?
    let founded: Int?
    let venue: String?

    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
        let area = json["area"] as? [String: Any],
        let areaName = area["name"] as? String,
        let name = json["name"] as? String
        else { return nil }

        self.id = id
        self.areaName = areaName
        self.name = name
        self.crestUrl = json["crestUrl"] as? String ?? nil
        self.address = json["address"] as? String ?? nil
        self.phone = json["phone"] as? String ?? nil
        self.website = json["website"] as? String ?? nil
        self.email = json["email"] as? String ?? nil
        self.founded = json["founded"] as? Int ?? nil
        self.venue = json["venue"] as? String ?? nil
    }
}
