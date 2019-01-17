//
//  TeamInfoViewController.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 12/12/18.
//  Copyright © 2018 Valerii Petrychenko. All rights reserved.
//

import UIKit
import Macaw
import RealmSwift

class TeamInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private struct Constants {
        static let MatchTableViewCell = "MatchTableViewCell"
        static let HeightSizeMatchTableViewCell: CGFloat = 50
        static let adress = "Address: "
        static let phone = "Phone: "
        static let website = "Website: "
        static let email = "Email: "
        static let stadium = "Stadium: "
        static let emptyFill = ""
    }

    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var matchesTableView: UITableView!

    @IBOutlet weak var teamNameAndAreaLAbel: UILabel!
    @IBOutlet weak var foundedLabel: UILabel!

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var stadiumLabel: UILabel!
    
    var teamDB: TeamDB!

    var currentTeamMatches = [Match]()
    var forFirstLoad = true

    var viewForActivityIndicator: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        matchesTableView.delegate = self
        matchesTableView.dataSource = self

        setUpUI()

        getTeamRequest(teamId: teamDB.teamId)
        getMatchesByCurrentTeam(teamId: teamDB.teamId)

    }

    private func getMatchesByCurrentTeam(teamId: String) {
        MatchesRequestService().getMatchesByTeam(teamId: teamId) { (matches, error) in
            if let matches = matches {
                self.currentTeamMatches = matches
            } else if let error = error {
                self.showAlert(title: "getMatchesRequest", message: error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.matchesTableView.reloadData()
            }
        }
    }

    private func getTeamRequest(teamId: String) {
        TeamRequestService().getTeam(teamId: teamId, callBack: { team, error in
            if let team = team {
                DispatchQueue.main.async {
                    self.configure(with: team)
                }
                self.imageView.dowloadFromServer(link: team.crestUrl ?? "", imageCach: nil)
            } else if let error = error {
                self.showAlert(title: "getTeamRequest",
                               message: error.localizedDescription)
            }
            self.stopLoader(viewForRemove: self.viewForActivityIndicator)
        })
    }

    private func configure(with team: Team) {
        teamNameAndAreaLAbel.text = team.name + " (" + team.areaName + ")"
        foundedLabel.text = team.founded != nil ? String(team.founded!) : Constants.emptyFill
        addressLabel.text = Constants.adress + (team.address ?? Constants.emptyFill)
        phoneLabel.text = Constants.phone + (team.phone ?? Constants.emptyFill)
        websiteLabel.text = Constants.website + (team.website ?? Constants.emptyFill)
        emailLabel.text = Constants.email + (team.email ?? Constants.emptyFill)
        stadiumLabel.text = Constants.stadium + (team.venue ?? Constants.emptyFill)
    }

    private func setUpUI() {
        viewForActivityIndicator = startLoader()

        matchesTableView.register(UINib(nibName: Constants.MatchTableViewCell, bundle: nil),
                                  forCellReuseIdentifier: Constants.MatchTableViewCell)

        matchesTableView.allowsSelection = false

        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(closeViewController))
        navigationItem.leftBarButtonItem = cancel

        let starImage = UIImage(named: "favorite")
        let starButton = UIBarButtonItem(image: starImage, style: .plain, target: self, action: #selector(favoriteTapped(sender:)))
        do {
            let realm = try Realm()
            let scope = realm.objects(TeamDB.self).filter("teamId == %@", teamDB.teamId)
            if scope.first != nil {
                starButton.tintColor = UIColor.orange
            } else {
                starButton.tintColor = UIColor.gray
            }
        } catch {
            print(error.localizedDescription)
        }
        navigationItem.rightBarButtonItem = starButton
    }

    @objc private func favoriteTapped(sender: UIBarButtonItem) {
        if sender.tintColor == UIColor.orange {
            deleteTeamFromRealm(teamDB: teamDB)
            sender.tintColor = UIColor.gray
        } else if sender.tintColor == UIColor.gray {
            addTeamToRealm(teamDB: teamDB)
            sender.tintColor = UIColor.orange
        }
    }

    @objc private func closeViewController() {
        dismiss(animated: true, completion: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTeamMatches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = matchesTableView.dequeueReusableCell(withIdentifier: Constants.MatchTableViewCell, for: indexPath) as! MatchTableViewCell
        cell.configure(with: currentTeamMatches[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.HeightSizeMatchTableViewCell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if forFirstLoad {
            if let matchForRow = self.currentTeamMatches.filter( {$0.utcDate >= Date() }).first {
                let indexOfMatch = self.currentTeamMatches.index(of: matchForRow)
                let indexPath = IndexPath(row: indexOfMatch!, section: 0)
                self.matchesTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                forFirstLoad = false
            }
        }
    }
}
