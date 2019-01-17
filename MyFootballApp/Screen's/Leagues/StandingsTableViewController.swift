//
//  StandingsTableViewController.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 12/12/18.
//  Copyright © 2018 Valerii Petrychenko. All rights reserved.
//

import UIKit
import Macaw

class StandingsTableViewController: UITableViewController {

    private struct Constants {
        static let LeagueStandingForTeamTableViewCell = "LeagueStandingForTeamTableViewCell"
        static let HeightSizeLeagueStandingForTeamTableViewCell: CGFloat = 50
        static let TeamInfoViewController = "TeamInfoViewController"
        static let RegularSeason = "REGULAR_SEASON"
        static let GroupStage = "GROUP_STAGE"
        static let StandingsType = "TOTAL"
    }

    var league: League!

    private let imageCach = NSCache<NSString, UIView>()

    private var listOfStandings = [Standings]()
    private var listOfStandingsWithSections = [[Standings]]()
    private var sectionTitles = [String]()

    private var listOfImagesForTeamWithSections = [[UIView]]()

    var viewForActivityIndicator: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()

        getStandingsRequest()
    }

    private func setUpUI() {
        tableView.tableFooterView = UIView()
        viewForActivityIndicator = startLoader()
        
        tableView.register(UINib(nibName: Constants.LeagueStandingForTeamTableViewCell, bundle: nil),
                           forHeaderFooterViewReuseIdentifier: Constants.LeagueStandingForTeamTableViewCell)

        tableView.register(UINib(nibName: Constants.LeagueStandingForTeamTableViewCell, bundle: nil),
                           forCellReuseIdentifier: Constants.LeagueStandingForTeamTableViewCell)
    }

    private func getStandingsRequest() {
        StandingsRequestService().getStandings(leagueId: String(league.id), callBack: { standings, error in
            if let standings = standings {
                self.listOfStandings = standings
                var standingsDictionary = [Standings : String]()

                for eachStandings in self.listOfStandings {
                    if eachStandings.type == Constants.StandingsType {
                        standingsDictionary[eachStandings] = eachStandings.group ?? eachStandings.stage
                    }
                }

                let (listOfStandingsByGroup, ArrayTitles) = self.sortDictonaryForTableView(inputDictionary: standingsDictionary)
                self.listOfStandingsWithSections = listOfStandingsByGroup as! [[Standings]]
                self.sectionTitles = ArrayTitles

            } else if let error = error {
                self.showAlert(title: "getStandingsRequest",
                               message: error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            self.stopLoader(viewForRemove: self.viewForActivityIndicator)
        })

    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfStandingsWithSections[section][0].table.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.LeagueStandingForTeamTableViewCell, for: indexPath) as! LeagueStandingForTeamTableViewCell
        cell.configure(with: listOfStandingsWithSections[indexPath.section][0].table[indexPath.row], sectionHeader: nil)

        let urlString = listOfStandingsWithSections[indexPath.section][0].table[indexPath.row].teamCrestUrl
        if let cachedImage = imageCach.object(forKey: NSString(string: urlString)) {
            cell.teamImageView.addSubview(cachedImage)
        } else {
            cell.teamImageView.dowloadFromServer(link: urlString, imageCach: imageCach)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: Constants.LeagueStandingForTeamTableViewCell) as! LeagueStandingForTeamTableViewCell
        header.configure(with: nil, sectionHeader: sectionTitles[section])
        header.backgroundColor = AppConstants.UIConstants.standardHeaderColor
        return header
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.HeightSizeLeagueStandingForTeamTableViewCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let teamDB = TeamDB(teamId: String(listOfStandingsWithSections[indexPath.section][0].table[indexPath.row].teamId),
                            teamName: String(listOfStandingsWithSections[indexPath.section][0].table[indexPath.row].teamName))
        instantiateTeamInfoViewController(teamDB: teamDB)
    }

}
