//
//  League.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 11/30/18.
//  Copyright © 2018 Valerii Petrychenko. All rights reserved.
//

import Foundation

class League {

    let areaName: String
    let name: String
    let code: String
    let currentSeasonStartDate: String
    let currentSeasonEndDate: String
    let currentMatchday: Int
    //let winner: String
    let numberOfAvailableSeasons: Int

    init?(json: [String: Any]) {
        guard let area = json["area"] as? [String: Any],
            let areaName = area["name"] as? String,
            let name = json["name"] as? String,
            let code = json["code"] as? String,
            let currentSeason = json["currentSeason"] as? [String: Any],
            let currentSeasonStartDate = currentSeason["startDate"] as? String,
            let currentSeasonEndDate = currentSeason["endDate"] as? String,
            let currentMatchday = currentSeason["currentMatchday"] as? Int,
            //let winner =
            let numberOfAvailableSeasons = json["numberOfAvailableSeasons"] as? Int
            else { return nil }

        self.areaName = areaName
        self.name = name
        self.code = code
        self.currentSeasonStartDate = currentSeasonStartDate
        self.currentSeasonEndDate = currentSeasonEndDate
        self.currentMatchday = currentMatchday
        self.numberOfAvailableSeasons = numberOfAvailableSeasons
    }

}
