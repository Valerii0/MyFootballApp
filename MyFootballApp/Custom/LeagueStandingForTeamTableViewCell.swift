//
//  LeagueStandingForTeamTableViewCell.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 12/11/18.
//  Copyright © 2018 Valerii Petrychenko. All rights reserved.
//

import UIKit
import WebKit

class LeagueStandingForTeamTableViewCell: UITableViewCell {

    private struct Constants {
        static let TeamStatisticView = "TeamStatisticView"
    }

    @IBOutlet weak var teamPositionLabel: UILabel!
    @IBOutlet weak var teamImageView: UIView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var rightContainerView: UIView!
    @IBOutlet weak var leftContainerView: UIView!

    let teamStatisticView: TeamStatisticView = UIView.fromNib()

    func configure(with table: Table?, sectionHeader: String?) {

        for view in teamImageView.subviews {
            view.removeFromSuperview()
        }

        if let table = table {
            teamPositionLabel.text = "\(table.position)"
            teamNameLabel.text = table.teamName
        } else if let sectionHeader = sectionHeader {
            teamPositionLabel.text = ""
            teamNameLabel.text = sectionHeader
            teamImageView.backgroundColor = AppConstants.UIConstants.standardHeaderColor
        }
        
        setUpUI(with: table)
    }

    private func setUpUI(with table: Table?) {
        if table == nil {
            leftContainerView.backgroundColor = AppConstants.UIConstants.standardHeaderColor
        }
        teamStatisticView.configure(with: table)
        teamStatisticView.frame =  CGRect(x:0, y: 0,
                                          width: rightContainerView.frame.width,
                                          height: rightContainerView.frame.height)

        rightContainerView.addSubview(teamStatisticView)
        NSLayoutConstraint.activate([
            teamStatisticView.leftAnchor.constraint(equalTo: rightContainerView.leftAnchor),
            teamStatisticView.topAnchor.constraint(equalTo: rightContainerView.topAnchor),
            teamStatisticView.rightAnchor.constraint(equalTo: rightContainerView.rightAnchor),
            teamStatisticView.bottomAnchor.constraint(equalTo: rightContainerView.bottomAnchor)
        ])
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
