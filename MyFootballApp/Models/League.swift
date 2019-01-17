//
//  League.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 11/30/18.
//  Copyright © 2018 Valerii Petrychenko. All rights reserved.
//

import Foundation

class League: NSObject {

    let id: Int
    let areaId: Int
    let areaName: String
    let name: String
    let code: String
    let currentSeasonStartDate: String
    let currentSeasonEndDate: String
    let currentMatchday: Int
    let numberOfAvailableSeasons: Int

    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let area = json["area"] as? [String: Any],
            let areaId = area["id"] as? Int,
            let areaName = area["name"] as? String,
            let name = json["name"] as? String,
            let code = json["code"] as? String,
            let currentSeason = json["currentSeason"] as? [String: Any],
            let currentSeasonStartDate = currentSeason["startDate"] as? String,
            let currentSeasonEndDate = currentSeason["endDate"] as? String,
            let currentMatchday = currentSeason["currentMatchday"] as? Int,
            let numberOfAvailableSeasons = json["numberOfAvailableSeasons"] as? Int
            else { return nil }

        self.id = id
        self.areaId = areaId
        self.areaName = areaName
        self.name = name
        self.code = code
        self.currentSeasonStartDate = currentSeasonStartDate
        self.currentSeasonEndDate = currentSeasonEndDate
        self.currentMatchday = currentMatchday
        self.numberOfAvailableSeasons = numberOfAvailableSeasons
    }

}
