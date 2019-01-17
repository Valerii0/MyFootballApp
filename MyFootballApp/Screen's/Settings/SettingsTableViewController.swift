//
//  SettingsTableViewController.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 1/5/19.
//  Copyright © 2019 Valerii Petrychenko. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import FirebaseDatabase

class SettingsTableViewController: UITableViewController {

    private struct Constants {
        static let loginStoryboard = "LoginSignUp"
        static let cellSpacingHeight: CGFloat = 200
        static let cellHeight: CGFloat = 50
        static let logoutMessage = "Are you sure you want to logout?"
        static let logoutAndDeleteMessage = "Are you sure you want to logout and delete your account? All favorites team will be loose forever!"
        static let askToChangeNotificationsSettings = "Are you sure you want to open settings and change notification parameter?"
    }

    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var hiddenCheckView: UIView!
    @IBOutlet weak var loginFillLabel: UILabel!
    
    let notifications = LocalPushNotifications()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }

    private func setUpUI() {
        tableView.alwaysBounceVertical = false
        tableView.allowsSelection = false

        notificationsSwitch.isEnabled = false
        setUpNotificationSwitch()
        createGestureRecognizerForView(view: hiddenCheckView)

        if let user = Auth.auth().currentUser {
            loginFillLabel.text = user.email
        } else {
            loginFillLabel.text = "??"
        }

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    private func setUpNotificationSwitch() {
        notifications.notificationCheck { (check) in
            DispatchQueue.main.async {
                self.notificationsSwitch.isOn = check
                self.tableView.reloadData()
            }
        }
    }

    private func createGestureRecognizerForView(view: UIView) {
        let TapGestureUiRecognizer = UITapGestureRecognizer()
        TapGestureUiRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(TapGestureUiRecognizer)
        view.isUserInteractionEnabled = true
        TapGestureUiRecognizer.addTarget(self, action: #selector(actionFuncForView(sender:)))
    }

    @objc private func actionFuncForView(sender: UITapGestureRecognizer) {
        askAlert(title: nil, message: Constants.askToChangeNotificationsSettings) { (yes, cancel) in
            if yes == true {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
        }
    }

    @objc func appMovedToForeground() {
        setUpNotificationSwitch()
    }

    @IBAction func reloadNotificationsAction(_ sender: UIButton) {
        sender.buttonPressEffect()

        notifications.notificationCheck { (check) in
            if check {
                self.notifications.checkAllTeamsMatchesForNotifications()
            }
        }
    }

    @IBAction func logoutAction(_ sender: UIButton) {
        sender.buttonPressEffect()

        if let user = Auth.auth().currentUser {
            askAlert(title: nil, message: Constants.logoutMessage) { (yes, cancel) in
                if yes == true {
                    do {
                        self.clearTeamsFireBase(user: user)
                        self.loadTeamsFromRealmToFireBase()
                        self.clearRealm()
                        try Auth.auth().signOut()
                        self.notifications.deleteAllScheduledNotificationExceptDefault()
                        self.instantiateLoginScreen()
                    } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                    }
                }
            }
        }
    }

    @IBAction func logoutAndDeleteAction(_ sender: UIButton) {
        sender.buttonPressEffect()

        if let user = Auth.auth().currentUser {
            askAlert(title: nil, message: Constants.logoutAndDeleteMessage) { (yes, cancel) in
                if yes == true {
                    user.delete { error in
                        if let error = error {
                            self.showAlert(title: "Error", message: error.localizedDescription)
                        } else {
                            self.clearRealm()
                            self.clearUserFireBase(user: user)
                            self.notifications.deleteAllScheduledNotificationExceptDefault()
                            self.instantiateLoginScreen()
                        }
                    }
                }
            }
        }
    }

    private func instantiateLoginScreen() {
        let storyboard = UIStoryboard(name: Constants.loginStoryboard, bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }

    private func loadTeamsFromRealmToFireBase() {
        do {
            guard let user = Auth.auth().currentUser else { return }
            let realm = try Realm()
            let teams = realm.objects(TeamDB.self)
            let newTeamRef = Database.database().reference().child("Users").child(user.uid).child("Teams")
            for team in teams {
                newTeamRef.child("Team: " + team.teamName).setValue(team.toDictionary())
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    private func clearUserFireBase(user: User) {
        Database.database().reference().child("Users").child(user.uid).removeValue()
    }

    private func clearTeamsFireBase(user: User) {
        Database.database().reference().child("Users").child(user.uid).child("Teams").removeValue()
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.clear
            return headerView
        } else {
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return Constants.cellSpacingHeight
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
}
