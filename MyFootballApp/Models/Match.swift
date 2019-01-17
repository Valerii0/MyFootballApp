//
//  Match.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 12/3/18.
//  Copyright © 2018 Valerii Petrychenko. All rights reserved.
//

import Foundation

@objc class Match: NSObject {

    let id: Int
    var competitionId: Int?
    var competitionName: String?
    let seasonStartDate: String
    let seasonEndDate: String
    let seasonCurrentMatchday: Int
    let seasonWinner: String?
    let utcDate: Date
    let status: String
    let matchday: Int
    let stage: String
    let group: String
    let scoreWinner: String?
    let scoreDuration: String
    let scoreFullTimeHomeTeam: Int?
    let scoreFullTimeAwayTeam: Int?
    let scoreHalfTimeHomeTeam: Int?
    let scoreHalfTimeAwayTeam: Int?
    let scoreExtraTimeHomeTeam: Int?
    let scoreExtraTimeAwayTeam: Int?
    let scorePenaltiesHomeTeam: Int?
    let scorePenaltiesAwayTeam: Int?
    let homeTeamId: Int
    let homeTeamName: String
    let awayTeamId: Int
    let awayTeamName: String

    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let season = json["season"] as? [String: Any],
            let seasonStartDate = season["startDate"] as? String,
            let seasonEndDate = season["endDate"] as? String,
            let seasonCurrentMatchday = season["currentMatchday"] as? Int,
            let utcDateString = json["utcDate"] as? String,
            let status = json["status"] as? String,
            let matchday = json["matchday"] as? Int,
            let stage = json["stage"] as? String,
            let group = json["group"] as? String,
            let score = json["score"] as? [String: Any],
            let scoreDuration = score["duration"] as? String,
            let homeTeam = json["homeTeam"] as? [String: Any],
            let homeTeamId = homeTeam["id"] as? Int,
            let homeTeamName = homeTeam["name"] as? String,
            let awayTeam = json["awayTeam"] as? [String: Any],
            let awayTeamId = awayTeam["id"] as? Int,
            let awayTeamName = awayTeam["name"] as? String
            else { return nil }

        self.id = id
        if let competition = json["competition"] as? [String: Any] {
            self.competitionId = competition["id"] as? Int ?? nil
            self.competitionName = competition["name"] as? String ?? nil
        } else {
            self.competitionId = nil
            self.competitionName = nil
        }
        self.seasonStartDate = seasonStartDate
        self.seasonEndDate = seasonEndDate
        self.seasonCurrentMatchday = seasonCurrentMatchday
        self.seasonWinner = season["winner"] as? String ?? nil

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.utcDate = formatter.date(from: utcDateString)!

        self.status = status
        self.matchday = matchday
        self.stage = stage
        self.group = group
        self.scoreWinner = score["winner"] as? String ?? nil
        self.scoreDuration = scoreDuration

        if let scoreFullTime = score["fullTime"] as? [String: Any] {
            self.scoreFullTimeHomeTeam = scoreFullTime["homeTeam"] as? Int ?? nil
            self.scoreFullTimeAwayTeam = scoreFullTime["awayTeam"] as? Int ?? nil
        } else {
            self.scoreFullTimeHomeTeam = nil
            self.scoreFullTimeAwayTeam = nil
        }

        if let scoreHalfTime = score["halfTime"] as? [String: Any] {
            self.scoreHalfTimeHomeTeam = scoreHalfTime["homeTeam"] as? Int ?? nil
            self.scoreHalfTimeAwayTeam = scoreHalfTime["awayTeam"] as? Int ?? nil
        } else {
            self.scoreHalfTimeHomeTeam = nil
            self.scoreHalfTimeAwayTeam = nil
        }

        if let scoreExtraTime = score["awayTeam"] as? [String: Any] {
            self.scoreExtraTimeHomeTeam = scoreExtraTime["homeTeam"] as? Int ?? nil
            self.scoreExtraTimeAwayTeam = scoreExtraTime["awayTeam"] as? Int ?? nil
        } else {
            self.scoreExtraTimeHomeTeam = nil
            self.scoreExtraTimeAwayTeam = nil
        }

        if let scorePenalties = score["penalties"] as? [String: Any] {
            self.scorePenaltiesHomeTeam = scorePenalties["homeTeam"] as? Int ?? nil
            self.scorePenaltiesAwayTeam = scorePenalties["awayTeam"] as? Int ?? nil
        } else {
            self.scorePenaltiesHomeTeam = nil
            self.scorePenaltiesAwayTeam = nil
        }

        self.homeTeamId = homeTeamId
        self.homeTeamName = homeTeamName
        self.awayTeamId = awayTeamId
        self.awayTeamName = awayTeamName
    }
}
