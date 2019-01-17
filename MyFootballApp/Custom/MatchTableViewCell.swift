//
//  MatchTableViewCell.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 12/8/18.
//  Copyright © 2018 Valerii Petrychenko. All rights reserved.
//

import UIKit

class MatchTableViewCell: UITableViewCell {

    private struct Constants {
        static let MatchTableViewCell = "MatchTableViewCell"
        static let DateFormat = "MMM d, h:mm a"
        static let Locale = "en_US_POSIX"
        static let Finished = "FINISHED"
        static let Postoned = "POSTPONED"
    }
    
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var scoreDateLabel: UILabel!
    @IBOutlet weak var awayTeamLabel: UILabel!

    func configure(with match: Match) {
        homeTeamLabel.text = match.homeTeamName
        awayTeamLabel.text = match.awayTeamName
        if let scoreHomeTeam = match.scoreFullTimeHomeTeam,
           let scoreAwayTeam = match.scoreFullTimeAwayTeam {
            scoreDateLabel.text = String(scoreHomeTeam) + " : " + String(scoreAwayTeam)
        } else if match.status == Constants.Postoned {
            scoreDateLabel.text = Constants.Postoned
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: Constants.Locale)
            dateFormatter.dateFormat = Constants.DateFormat
            let showDate = dateFormatter.string(from: match.utcDate)
            scoreDateLabel.text = showDate
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
