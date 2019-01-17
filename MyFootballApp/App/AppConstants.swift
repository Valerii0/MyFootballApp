//
//  AppConstants.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 11/30/18.
//  Copyright © 2018 Valerii Petrychenko. All rights reserved.
//

import Foundation
import UIKit

struct AppConstants {

    struct RequestsConstants {
        static let urlString = "https://api.football-data.org/v2/"

        static let keyForFreePlanName = "X-Auth-Token"
        static let keyForFreePlanValue = "76da21b7e521415ab76306e7a640b5e3"

        static let planName = "plan"
        static let planValue = "TIER_ONE"

        static let competitions = "competitions/"
        static let matches = "matches/"
        static let standings = "standings/"
        static let teams = "teams/"

        static let area = "area"
        static let name = "name"

        static let dateFrom = "dateFrom"
        static let dateTo = "dateTo"

        static let dateFormat = "yyyy-MM-dd"
    }

    struct UIConstants {
        static let standardHeaderColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
    }

    struct NavigationConstants {
        static let storyboard = "Main"
        static let identifierForMainTabBar = "mainTabBar"

    }

    struct PushNotificationsConstants {
        static let localPushNotifications = "LocalPushNotifications"
    }

    enum yesterdayTodayTomorrowForSegmentedControl: Int {
        case yesterday = 0
        case today = 1
        case tomorrow = 2
    }

    enum yesterdayTodayTomorrowForDaysCalculate: Int {
        case yesterday = -1
        case today = 0
        case tomorrow = 1
    }
}
