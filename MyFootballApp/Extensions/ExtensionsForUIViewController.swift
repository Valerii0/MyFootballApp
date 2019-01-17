//
//  ExtensionsForUIViewController.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 11/30/18.
//  Copyright © 2018 Valerii Petrychenko. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

extension UIViewController {

    ///Custom Alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }

    func askAlert(title: String?, message: String, callBack: @escaping (_ yes: Bool, _ cancel: Bool) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            callBack(true, false)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            callBack(false, true)
        }))
        present(alert, animated: true)
    }

    func stringShortDate(currentDate: Date, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = dateFormat
        let returnDate = dateFormatter.string(from: currentDate)
        return returnDate
    }

    func sortDictonaryForTableView(inputDictionary: [AnyHashable: String]) -> ([[AnyHashable]], [String]) {
        var titles = [String]()
        var sortedListOfObjectsWithSections = [[AnyHashable]]()
        if inputDictionary.keys.count == 1 {
            let firstKey = Array(inputDictionary.keys)[0]
            sortedListOfObjectsWithSections.append([firstKey])
            titles.append(inputDictionary[firstKey] ?? "")
        }
        else if inputDictionary.keys.count > 1 {
            let sortedValues = inputDictionary.values.sorted { $0 < $1 }
            var sortedValuesWithOutDuplicates = [String]()

            for value in sortedValues {
                if !sortedValuesWithOutDuplicates.contains(value) {
                    sortedValuesWithOutDuplicates.append(value)
                }
            }

            for sortedValueIndex in 0..<sortedValuesWithOutDuplicates.count {
                titles.append(sortedValuesWithOutDuplicates[sortedValueIndex])
                sortedListOfObjectsWithSections.append([])
                for element in inputDictionary.keys {
                    if let value = inputDictionary[element] {
                        if value == sortedValuesWithOutDuplicates[sortedValueIndex] {
                            sortedListOfObjectsWithSections[sortedValueIndex].append(element)
                        }
                    }
                }
            }
        }
        return (sortedListOfObjectsWithSections, titles)
    }

    func instantiateTeamInfoViewController(teamDB: TeamDB) {
        if let teamInfoViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TeamInfoViewController") as? TeamInfoViewController {

            let navigationController = UINavigationController(rootViewController: teamInfoViewController)
            teamInfoViewController.teamDB = teamDB
            present(navigationController, animated: true)
        }
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func addTeamToRealm(teamDB: TeamDB) {
        let teamToAdd = TeamDB(teamId: teamDB.teamId, teamName: teamDB.teamName)
        do {
            let realm = try Realm()
            do {
                try realm.write {
                    realm.add(teamToAdd)
                }
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func deleteTeamFromRealm(teamDB: TeamDB) {
        do {
            let realm = try Realm()
            do {
                try realm.write {
                    realm.delete(realm.objects(TeamDB.self).filter("teamId == %@", teamDB.teamId))
                }
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func clearRealm() {
        do {
            let realm = try Realm()
            do {
                try realm.write {
                    realm.delete(realm.objects(TeamDB.self))
                }
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func setEmptyMessage(_ message: String, tableView: UITableView) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        tableView.backgroundView = messageLabel;
        tableView.separatorStyle = .none;
    }

    func restore(tableView: UITableView) {
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
    }

    func startLoader() -> UIView {
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        backgroundView.backgroundColor = .white
        let activityView = UIActivityIndicatorView(style: .gray)
        activityView.center = self.view.center
        activityView.startAnimating()
        backgroundView.addSubview(activityView)
        self.view.addSubview(backgroundView)
        return backgroundView
    }

    func stopLoader(viewForRemove: UIView) {
        DispatchQueue.main.async {
            viewForRemove.removeFromSuperview()
        }
    }

}
