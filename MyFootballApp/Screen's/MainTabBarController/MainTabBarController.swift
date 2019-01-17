//
//  MainTabBarController.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 1/16/19.
//  Copyright © 2019 Valerii Petrychenko. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    private struct Constants {
        static let matchDay = "Matchday"
        static let imageForMatchDay = "match"
        static let competitions = "Competitions"
        static let imageForCompetitions = "trophy"
        static let favorites = "Favorites"
        static let imageForFavorites = "tabBarFavorite"
        static let settings = "Settings"
        static let imageForSettings = "settings"
    }

    @IBOutlet weak var MainTabBar: UITabBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        setTabBarUI()
    }

    private func setTabBarUI() {
        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        myTabBarItem1.image = UIImage(named: Constants.imageForMatchDay)
        myTabBarItem1.title = Constants.matchDay

        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage(named: Constants.imageForCompetitions)
        myTabBarItem2.title = Constants.competitions


        let myTabBarItem3 = (self.tabBar.items?[2])! as UITabBarItem
        myTabBarItem3.image = UIImage(named: Constants.imageForFavorites)
        myTabBarItem3.title = Constants.favorites

        let myTabBarItem4 = (self.tabBar.items?[3])! as UITabBarItem
        myTabBarItem4.image = UIImage(named: Constants.imageForSettings)
        myTabBarItem4.title = Constants.settings
    }
}
