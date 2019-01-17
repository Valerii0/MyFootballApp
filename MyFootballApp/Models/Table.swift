//
//  Table.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 12/12/18.
//  Copyright © 2018 Valerii Petrychenko. All rights reserved.
//

import Foundation
import UIKit

class Table {
    let position: Int
    let teamId: Int
    let teamName: String
    let teamCrestUrl: String
    let playedGames: Int
    let won: Int
    let draw: Int
    let lost: Int
    let points: Int
    let goalsFor: Int
    let goalsAgainst: Int
    let goalDifference: Int

    init?(json: [String: Any]) {
        guard let position = json["position"] as? Int,
            let team = json["team"] as? [String: Any],
            let teamId = team["id"] as? Int,
            let teamName = team["name"] as? String,
            let teamCrestUrl = team["crestUrl"] as? String,
            let playedGames = json["playedGames"] as? Int,
            let won = json["won"] as? Int,
            let draw = json["draw"] as? Int,
            let lost = json["lost"] as? Int,
            let points = json["points"] as? Int,
            let goalsFor = json["goalsFor"] as? Int,
            let goalsAgainst = json["goalsAgainst"] as? Int,
            let goalDifference = json["goalDifference"] as? Int
            else { return nil }

        self.position = position
        self.teamId = teamId
        self.teamName = teamName
        self.teamCrestUrl = teamCrestUrl
        self.playedGames = playedGames
        self.won = won
        self.draw = draw
        self.lost = lost
        self.points = points
        self.goalsFor = goalsFor
        self.goalsAgainst = goalsAgainst
        self.goalDifference = goalDifference

    }
}
