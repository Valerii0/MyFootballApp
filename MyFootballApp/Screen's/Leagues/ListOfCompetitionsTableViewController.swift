//
//  ListOfCompetitionsTableViewController.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 11/30/18.
//  Copyright © 2018 Valerii Petrychenko. All rights reserved.
//

import UIKit

class ListOfCompetitionsTableViewController: UITableViewController {

    // Constants
    private struct Constants {
        static let leagues = "Leagues"
        static let LeagueTableViewCell = "LeagueTableViewCell"
        static let HeightSizeLeagueTableViewCell: CGFloat = 100
        static let FromListOfCompetitionsToStandings = "FromListOfCompetitionsToStandings"
        static let messageForEmptyTableView = "No competition found. Try to pull down to refresh."
    }

    private var listOfLeagues = [League]()
    private var listOfLeaguesWithSections = [[League]]()
    private var sectionTitles = [String]()

    let competitionsRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()

        getLeaguesRequest()
    }

    private func setUpUI() {
        tableView.register(UINib(nibName: Constants.LeagueTableViewCell, bundle: nil),
                           forCellReuseIdentifier: Constants.LeagueTableViewCell)

        competitionsRefreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)

        tableView.addSubview(competitionsRefreshControl)
    }

    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        getLeaguesRequest()
        self.competitionsRefreshControl.endRefreshing()
    }

    private func getLeaguesRequest() {
        LeaguesRequestService().getLeagues { leagues, error in

            if let leagues = leagues {
                self.listOfLeagues = leagues
                var leaguesDictionary = [League : String]()

                for league in self.listOfLeagues {
                    leaguesDictionary[league] = league.areaName
                }

                let (listOfLeaguesByCompetitions, ArrayTitles) = self.sortDictonaryForTableView(inputDictionary: leaguesDictionary)
                self.listOfLeaguesWithSections = listOfLeaguesByCompetitions as! [[League]]
                self.sectionTitles = ArrayTitles

            } else if let error = error {
                self.showAlert(title: "getLeaguesRequest",
                               message: error.localizedDescription)
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if sectionTitles.count == 0 {
            self.setEmptyMessage(Constants.messageForEmptyTableView, tableView: tableView)
        } else {
            self.restore(tableView: tableView)
        }
        return sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfLeaguesWithSections[section].count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.LeagueTableViewCell, for: indexPath) as! LeagueTableViewCell
        cell.configure(with: listOfLeaguesWithSections[indexPath.section][indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.HeightSizeLeagueTableViewCell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.FromListOfCompetitionsToStandings, sender: listOfLeaguesWithSections[indexPath.section][indexPath.row])
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let standings = segue.destination as? StandingsTableViewController {
            standings.league = sender as? League
        }
    }
}
