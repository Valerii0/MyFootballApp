//
//  LeagueTableViewCell.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 12/8/18.
//  Copyright © 2018 Valerii Petrychenko. All rights reserved.
//

import UIKit

class LeagueTableViewCell: UITableViewCell {

    private struct Constants {
        static let Start = "Start: "
        static let End = "End: "
        static let Matchday = "Matchday: "
    }
    
    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var matchDayLabel: UILabel!

    func configure(with league: League) {
        leagueNameLabel.text = league.name
        startDateLabel.text = Constants.Start + league.currentSeasonStartDate
        endDateLabel.text = Constants.End + league.currentSeasonEndDate
        matchDayLabel.text = Constants.Matchday + "\(league.currentMatchday)"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
