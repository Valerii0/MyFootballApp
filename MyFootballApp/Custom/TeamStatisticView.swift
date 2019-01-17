//
//  TeamStatisticView.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 12/11/18.
//  Copyright © 2018 Valerii Petrychenko. All rights reserved.
//

import UIKit

class TeamStatisticView: UIView {

    private struct Constants {
        static let playedGames = "Pg"
        static let points = "Pt"
        static let won = "W"
        static let draw = "D"
        static let lost = "L"
        static let goalsFor = "Gs"
        static let goalsAgainst = "Gl"
        static let goalDifference = "Gd"
    }

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fifthLabel: UILabel!
    @IBOutlet weak var sixthLabel: UILabel!
    @IBOutlet weak var seventhLabel: UILabel!
    @IBOutlet weak var eighthLabel: UILabel!

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var fourthView: UIView!
    @IBOutlet weak var fifthView: UIView!
    @IBOutlet weak var sixthView: UIView!
    @IBOutlet weak var seventhView: UIView!
    @IBOutlet weak var eightView: UIView!

    func configure(with table: Table?) {
        if let table = table {
            firstLabel.text = String(table.playedGames)
            secondLabel.text = String(table.points)
            thirdLabel.text = String(table.won)
            fourthLabel.text = String(table.draw)
            fifthLabel.text = String(table.lost)
            sixthLabel.text = String(table.goalsFor)
            seventhLabel.text = String(table.goalsAgainst)
            eighthLabel.text = String(table.goalDifference)
        } else {
            firstLabel.text = Constants.playedGames
            secondLabel.text = Constants.points
            thirdLabel.text = Constants.won
            fourthLabel.text = Constants.draw
            fifthLabel.text = Constants.lost
            sixthLabel.text = Constants.goalsFor
            seventhLabel.text = Constants.goalsAgainst
            eighthLabel.text = Constants.goalDifference

            setUpUI()
        }
    }

    func setUpUI() {
        let viewsArray: [UIView] = [firstView, secondView, thirdView, fourthView, fifthView, sixthView, seventhView, eightView]

        for view in viewsArray {
            view.backgroundColor = AppConstants.UIConstants.standardHeaderColor
        }
    }

}
