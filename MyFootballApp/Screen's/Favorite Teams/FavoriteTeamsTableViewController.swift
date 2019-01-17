//
//  FavoriteTeamsTableViewController.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 12/29/18.
//  Copyright © 2018 Valerii Petrychenko. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteTeamsTableViewController: UITableViewController {

    private struct Constants {
        static let messageForEmptyTableView = "You have no favorite teams yet."
    }

    var teamsArray = [TeamDB]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        setUpUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTeamsFromRealm()
    }

    private func setUpUI() {
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.tableFooterView = UIView()
    }

    override func setEditing (_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if self.isEditing {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearAction))
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
    }

    @objc private func clearAction() {
        clearRealm()
        loadTeamsFromRealm()
    }

    private func loadTeamsFromRealm() {
        do {
            let realm = try Realm()
            let teams = realm.objects(TeamDB.self)
            teamsArray = Array(teams)
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if teamsArray.count == 0 {
            self.setEmptyMessage(Constants.messageForEmptyTableView, tableView: tableView)
        } else {
            self.restore(tableView: tableView)
        }
        return teamsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "standartCell", for: indexPath)
        cell.textLabel?.text = teamsArray[indexPath.row].teamName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        instantiateTeamInfoViewController(teamDB: teamsArray[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let teamDB = teamsArray[indexPath.row]
            deleteTeamFromRealm(teamDB: teamDB)
            self.teamsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
