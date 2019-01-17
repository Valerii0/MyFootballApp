//
//  DetailMatchViewController.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 12/12/18.
//  Copyright © 2018 Valerii Petrychenko. All rights reserved.
//

import UIKit

class DetailMatchViewController: UIViewController {

    private struct Constants {
        static let TeamInfoViewController = "TeamInfoViewController"
        static let MatchDetailInfo = "Match Detail"
        static let homeTeamWinner = "HOME_TEAM"
        static let awayTeamWinner = "AWAY_TEAM"
        static let matchDay = "Matchday: "
        static let firstHalf = "1'st Half"
        static let secondHalf = "2'nd Half"
        static let fullTime = "Full Time"
        static let extraTime = "Extra Time"
        static let penalties = "Penalties"
        static let dateFormat = "E, d MMM yyyy, HH:mm"
        static let noScore = "- : -"
        static let divider = " : "
    }

    @IBOutlet weak var matchDayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var awayTeamLabel: UILabel!
    @IBOutlet weak var firstHalfLabel: UILabel!
    @IBOutlet weak var firstHalfScoreLabel: UILabel!
    @IBOutlet weak var secondHalfLabel: UILabel!
    @IBOutlet weak var secondHalfScorelabel: UILabel!
    @IBOutlet weak var fullTimeLabel: UILabel!
    @IBOutlet weak var fullTineScoreLabel: UILabel!
    @IBOutlet weak var extraTimeLabel: UILabel!
    @IBOutlet weak var extraTimeScoreLabel: UILabel!
    @IBOutlet weak var penaltiesLabel: UILabel!
    @IBOutlet weak var penaltiesScoreLabel: UILabel!

    var match: Match!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    
    private func setUpUI() {
        self.title = Constants.MatchDetailInfo
        matchDayLabel.text = Constants.matchDay + "\(match.matchday)"
        dateLabel.text = stringShortDate(currentDate: match.utcDate, dateFormat: Constants.dateFormat)
        statusLabel.text = match.status
        groupLabel.text = match.group
        homeTeamLabel.attributedText = NSAttributedString(string: match.homeTeamName, attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        scoreLabel.text = mainScoreFillForSetUpUI(homeTeamFullTimeScore: match.scoreFullTimeHomeTeam,
                                                  awayTeamFullTimeScore: match.scoreFullTimeAwayTeam,
                                                  homeTeamExtraTimeScore: match.scoreExtraTimeHomeTeam,
                                                  awayTeamExtraTimeScore: match.scoreExtraTimeAwayTeam,
                                                  homeTeamPenaltiesScore: match.scorePenaltiesHomeTeam,
                                                  awayTeamPenaltiesScore: match.scorePenaltiesAwayTeam)
        awayTeamLabel.attributedText = NSAttributedString(string: match.awayTeamName, attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        firstHalfLabel.text = Constants.firstHalf
        firstHalfScoreLabel.text = scoreFillForSetUpUI(homeTeamScore: match.scoreHalfTimeHomeTeam,
                                                       awayTeamScore: match.scoreHalfTimeAwayTeam)
        secondHalfLabel.text = Constants.secondHalf
        secondHalfScorelabel.text = secondHalfScore(homeTeamFirstHalfScore: match.scoreHalfTimeHomeTeam,
                                                    awayTeamFirstHalfScore: match.scoreHalfTimeAwayTeam,
                                                    homeTeamFullTimeScore: match.scoreFullTimeHomeTeam,
                                                    awayTeamFullTimeScore: match.scoreFullTimeAwayTeam)
        fullTimeLabel.text = Constants.fullTime
        fullTineScoreLabel.text = scoreFillForSetUpUI(homeTeamScore: match.scoreFullTimeHomeTeam,
                                                      awayTeamScore: match.scoreFullTimeAwayTeam)
        extraTimeLabel.text = Constants.extraTime
        extraTimeScoreLabel.text = scoreFillForSetUpUI(homeTeamScore: match.scoreExtraTimeHomeTeam,
                                                       awayTeamScore: match.scoreExtraTimeAwayTeam)
        penaltiesLabel.text = Constants.penalties
        penaltiesScoreLabel.text = scoreFillForSetUpUI(homeTeamScore: match.scorePenaltiesHomeTeam,
                                                       awayTeamScore: match.scorePenaltiesAwayTeam)

        homeTeamLabel.textColor = UIColor.blue
        awayTeamLabel.textColor = UIColor.blue
        if match.scoreWinner == Constants.homeTeamWinner {
            homeTeamLabel.font = UIFont.boldSystemFont(ofSize: homeTeamLabel.font.pointSize)
        } else if match.scoreWinner == Constants.awayTeamWinner {
            awayTeamLabel.font = UIFont.boldSystemFont(ofSize: awayTeamLabel.font.pointSize)
        }

        createGestureRecognizerForLabel(label: homeTeamLabel)
        createGestureRecognizerForLabel(label: awayTeamLabel)

    }

    private func createGestureRecognizerForLabel(label: UILabel) {
        let TapGestureUiRecognizer = UITapGestureRecognizer()
        TapGestureUiRecognizer.numberOfTapsRequired = 1
        label.addGestureRecognizer(TapGestureUiRecognizer)
        label.isUserInteractionEnabled = true
        TapGestureUiRecognizer.addTarget(self, action: #selector(actionFunc(sender:)))
    }

    @objc private func actionFunc(sender: UITapGestureRecognizer) {
        if sender.view == homeTeamLabel {
            let teamDB = TeamDB(teamId: String(match.homeTeamId), teamName: match.homeTeamName)
            instantiateTeamInfoViewController(teamDB: teamDB)
        } else if sender.view == awayTeamLabel {
            let teamDB = TeamDB(teamId: String(match.awayTeamId), teamName: match.awayTeamName)
            instantiateTeamInfoViewController(teamDB: teamDB)
        }
    }

    private func scoreFillForSetUpUI(homeTeamScore: Int?, awayTeamScore: Int?) -> String {
        if let homeTeamScore = homeTeamScore,
            let awayTeamScore = awayTeamScore {
            return String(homeTeamScore) + Constants.divider + String(awayTeamScore)
        } else {
            return Constants.noScore
        }
    }

    private func mainScoreFillForSetUpUI(homeTeamFullTimeScore: Int?,
                                         awayTeamFullTimeScore: Int?,
                                         homeTeamExtraTimeScore: Int?,
                                         awayTeamExtraTimeScore: Int?,
                                         homeTeamPenaltiesScore: Int?,
                                         awayTeamPenaltiesScore: Int?) -> String {

        if let homeTeamFullTimeScore = homeTeamFullTimeScore,
            let awayTeamFullTimeScore = awayTeamFullTimeScore {
            var homeTeamScore = homeTeamFullTimeScore
            var awayTeamScore = awayTeamFullTimeScore

            if let homeTeamExtraTimeScore = homeTeamExtraTimeScore,
                let awayTeamExtraTimeScore = awayTeamExtraTimeScore {
                homeTeamScore += homeTeamExtraTimeScore
                awayTeamScore += awayTeamExtraTimeScore
            }

            var returnScore = String(homeTeamScore) + Constants.divider + String(awayTeamScore)

            if let homeTeamPenaltiesScore = homeTeamPenaltiesScore,
                let awayTeamPenaltiesScore = awayTeamPenaltiesScore {
                returnScore += "\n(\(homeTeamPenaltiesScore) : \(awayTeamPenaltiesScore))"
            }
            return returnScore
        } else {
            return Constants.noScore
        }
    }

    private func secondHalfScore(homeTeamFirstHalfScore: Int?,
                                 awayTeamFirstHalfScore: Int?,
                                 homeTeamFullTimeScore: Int?,
                                 awayTeamFullTimeScore: Int?) -> String {

        if let homeTeamFirstHalfScore = homeTeamFirstHalfScore,
            let awayTeamFirstHalfScore = awayTeamFirstHalfScore,
            let homeTeamFullTimeScore = homeTeamFullTimeScore,
            let awayTeamFullTimeScore = awayTeamFullTimeScore {
            return String(homeTeamFullTimeScore - homeTeamFirstHalfScore) +
                   Constants.divider +
                   String(awayTeamFullTimeScore - awayTeamFirstHalfScore)
        } else {
            return Constants.noScore
        }
    }

}
