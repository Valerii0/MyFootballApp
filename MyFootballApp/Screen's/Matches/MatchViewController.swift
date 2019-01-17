//
//  MatchViewController.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 11/28/18.
//  Copyright © 2018 Valerii Petrychenko. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private struct Constants {
        static let MatchTableViewCell = "MatchTableViewCell"
        static let HeightSizeMatchTableViewCell: CGFloat = 80
        static let FromMatchToDetailMatch = "FromMatchToDetailMatch"
        static let messageForEmptyTableView = "No mathces for current day! Try to pull down to refresh."
        
    }

    private var yesterdayListOfMatches = [Match]()
    private var todayListOfMatches = [Match]()
    private var tomorrowListOfMatches = [Match]()

    private var yesterdayListOfMatchesWithSections = [[Match]]()
    private var todayListOfMatchesWithSections = [[Match]]()
    private var tomorrowListOfMatchesWithSections = [[Match]]()

    private var yesterdaySectionTitles = [String]()
    private var todaySectionTitles = [String]()
    private var tomorrowSectionTitles = [String]()

    @IBOutlet weak var chooseDateSegmentedControlOutlet: UISegmentedControl!
    @IBOutlet weak var presentMatchesTableViewOutlet: UITableView!

    let macthesRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()

        getMatchesRequest()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let index = self.presentMatchesTableViewOutlet.indexPathForSelectedRow {
            self.presentMatchesTableViewOutlet.deselectRow(at: index, animated: true)
        }
    }

    private func setUpUI() {
        presentMatchesTableViewOutlet.delegate = self
        presentMatchesTableViewOutlet.dataSource = self

        macthesRefreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)

        presentMatchesTableViewOutlet.addSubview(macthesRefreshControl)

        presentMatchesTableViewOutlet.register(UINib(nibName: Constants.MatchTableViewCell, bundle: nil),
                                               forCellReuseIdentifier: Constants.MatchTableViewCell)

        presentMatchesTableViewOutlet.tableFooterView = UIView()

    }

    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        getMatchesRequest()
        refreshControl.endRefreshing()
    }

    @IBAction func chooseDateSegmentedControlAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {

        } else if sender.selectedSegmentIndex == 1 {

        } else if sender.selectedSegmentIndex == 2 {

        }
        presentMatchesTableViewOutlet.reloadData()
    }

    private func getMatchesRequest () {

        let dateFrom = stringShortDate(currentDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, dateFormat: AppConstants.RequestsConstants.dateFormat)
        let dateTo = stringShortDate(currentDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, dateFormat: AppConstants.RequestsConstants.dateFormat)

        MatchesRequestService().getMatchesByDate(dateFrom: dateFrom, dateTo: dateTo) { matches, error in
            if let matches = matches {
                self.fillDaysArrays(listOfMatches: matches)

                var yesterdayListOfMatchesDictionary = [Match : String]()
                for match in self.yesterdayListOfMatches {
                    yesterdayListOfMatchesDictionary[match] = match.competitionName
                }
                let (yesterdaySortListOfMatchesByCompetitions, yesterdayArrayTitles) = self.sortDictonaryForTableView(inputDictionary: yesterdayListOfMatchesDictionary)
                self.yesterdayListOfMatchesWithSections = yesterdaySortListOfMatchesByCompetitions as! [[Match]]
                self.yesterdaySectionTitles = yesterdayArrayTitles

                var todayListOfMatchesDictionary = [Match : String]()
                for match in self.todayListOfMatches {
                    todayListOfMatchesDictionary[match] = match.competitionName
                }
                let (todaySortListOfMatchesByCompetitions, todayArrayTitles) = self.sortDictonaryForTableView(inputDictionary: todayListOfMatchesDictionary)
                self.todayListOfMatchesWithSections = todaySortListOfMatchesByCompetitions as! [[Match]]
                self.todaySectionTitles = todayArrayTitles

                var tomorrowListOfMatchesDictionary = [Match : String]()
                for match in self.tomorrowListOfMatches {
                    tomorrowListOfMatchesDictionary[match] = match.competitionName
                }
                let (tomorrowSortListOfMatchesByCompetitions, tmorrowArrayTitles) = self.sortDictonaryForTableView(inputDictionary: tomorrowListOfMatchesDictionary)
                self.tomorrowListOfMatchesWithSections = tomorrowSortListOfMatchesByCompetitions as! [[Match]]
                self.tomorrowSectionTitles = tmorrowArrayTitles

            } else  if let error = error {
                self.showAlert(title: "getMatchesRequest", message: error.localizedDescription)
            }

            DispatchQueue.main.async {
                self.presentMatchesTableViewOutlet.reloadData()
            }
        }
    }

    private func fillDaysArrays(listOfMatches: [Match]) {
        yesterdayListOfMatches.removeAll()
        todayListOfMatches.removeAll()
        tomorrowListOfMatches.removeAll()

        for match in listOfMatches {
            let dateComparison = Calendar.current.compare(Date(), to: match.utcDate, toGranularity: .day)

            switch dateComparison {
            case .orderedDescending:
                self.yesterdayListOfMatches.append(match)
            case .orderedSame:
                self.todayListOfMatches.append(match)
            case .orderedAscending:
                self.tomorrowListOfMatches.append(match)
            }
        }
    }

    //MARK: delegate methods.
    func numberOfSections(in tableView: UITableView) -> Int {
        var returnNumberOfSections = 0
        if chooseDateSegmentedControlOutlet.selectedSegmentIndex == AppConstants.yesterdayTodayTomorrowForSegmentedControl.yesterday.rawValue {
            returnNumberOfSections = yesterdaySectionTitles.count
        } else if chooseDateSegmentedControlOutlet.selectedSegmentIndex == AppConstants.yesterdayTodayTomorrowForSegmentedControl.today.rawValue {
            returnNumberOfSections = todaySectionTitles.count
        } else if chooseDateSegmentedControlOutlet.selectedSegmentIndex == AppConstants.yesterdayTodayTomorrowForSegmentedControl.tomorrow.rawValue {
            returnNumberOfSections = tomorrowSectionTitles.count
        }

        if returnNumberOfSections == 0 {
            self.setEmptyMessage(Constants.messageForEmptyTableView, tableView: presentMatchesTableViewOutlet)
        } else {
            self.restore(tableView: presentMatchesTableViewOutlet)
        }

        return returnNumberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if chooseDateSegmentedControlOutlet.selectedSegmentIndex == AppConstants.yesterdayTodayTomorrowForSegmentedControl.yesterday.rawValue {
            return yesterdayListOfMatchesWithSections[section].count
        } else if chooseDateSegmentedControlOutlet.selectedSegmentIndex == AppConstants.yesterdayTodayTomorrowForSegmentedControl.today.rawValue {
            return todayListOfMatchesWithSections[section].count
        } else if chooseDateSegmentedControlOutlet.selectedSegmentIndex == AppConstants.yesterdayTodayTomorrowForSegmentedControl.tomorrow.rawValue {
            return tomorrowListOfMatchesWithSections[section].count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = presentMatchesTableViewOutlet.dequeueReusableCell(withIdentifier: Constants.MatchTableViewCell, for: indexPath) as! MatchTableViewCell
        var listOfMatchesToShow = [[Match]]()
        if chooseDateSegmentedControlOutlet.selectedSegmentIndex == AppConstants.yesterdayTodayTomorrowForSegmentedControl.yesterday.rawValue {
            listOfMatchesToShow = yesterdayListOfMatchesWithSections
        } else if chooseDateSegmentedControlOutlet.selectedSegmentIndex == AppConstants.yesterdayTodayTomorrowForSegmentedControl.today.rawValue {
            listOfMatchesToShow = todayListOfMatchesWithSections
        } else if chooseDateSegmentedControlOutlet.selectedSegmentIndex == AppConstants.yesterdayTodayTomorrowForSegmentedControl.tomorrow.rawValue {
            listOfMatchesToShow = tomorrowListOfMatchesWithSections
        }
        cell.configure(with: listOfMatchesToShow[indexPath.section][indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if chooseDateSegmentedControlOutlet.selectedSegmentIndex == AppConstants.yesterdayTodayTomorrowForSegmentedControl.yesterday.rawValue {
            return yesterdaySectionTitles[section]
        } else if chooseDateSegmentedControlOutlet.selectedSegmentIndex == AppConstants.yesterdayTodayTomorrowForSegmentedControl.today.rawValue {
            return todaySectionTitles[section]
        } else if chooseDateSegmentedControlOutlet.selectedSegmentIndex == AppConstants.yesterdayTodayTomorrowForSegmentedControl.tomorrow.rawValue {
            return tomorrowSectionTitles[section]
        } else {
            return ""
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textAlignment = NSTextAlignment.center
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.HeightSizeMatchTableViewCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var listOfMatchesToShow = [[Match]]()
        if chooseDateSegmentedControlOutlet.selectedSegmentIndex == AppConstants.yesterdayTodayTomorrowForSegmentedControl.yesterday.rawValue {
            listOfMatchesToShow = yesterdayListOfMatchesWithSections
        } else if chooseDateSegmentedControlOutlet.selectedSegmentIndex == AppConstants.yesterdayTodayTomorrowForSegmentedControl.today.rawValue {
            listOfMatchesToShow = todayListOfMatchesWithSections
        } else if chooseDateSegmentedControlOutlet.selectedSegmentIndex == AppConstants.yesterdayTodayTomorrowForSegmentedControl.tomorrow.rawValue {
            listOfMatchesToShow = tomorrowListOfMatchesWithSections
        }

        performSegue(withIdentifier: Constants.FromMatchToDetailMatch, sender: listOfMatchesToShow[indexPath.section][indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let detailMatch = segue.destination as? DetailMatchViewController {
            detailMatch.match = sender as? Match
        }
    }
}

