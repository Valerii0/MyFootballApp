//
//  LoginViewController.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 1/4/19.
//  Copyright © 2019 Valerii Petrychenko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
    }

    @IBAction func loginAction(_ sender: UIButton) {
        sender.buttonPressEffect()

        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if let user = user?.user {
                let mainTabBAr = UIStoryboard.init(name: AppConstants.NavigationConstants.storyboard, bundle: nil).instantiateViewController(withIdentifier: AppConstants.NavigationConstants.identifierForMainTabBar)
                self.present(mainTabBAr, animated: true)
                self.loadTeamsFromFireBaseToRealm(user: user)
                //self.performSegue(withIdentifier: "loginToHome", sender: self)
            } else {
                self.showAlert(title: "Error", message: (error?.localizedDescription)!)
            }
        }
    }

    func loadTeamsFromFireBaseToRealm(user: User) {
        let newTeamRef = Database.database().reference().child("Users").child(user.uid)
        newTeamRef.observeSingleEvent(of: .value, with: { snapshot in
            guard let postDict = snapshot.value as? [String : AnyObject],
                let teams = postDict["Teams"] as? [String : AnyObject]
                else { return }
            for team in teams {
                guard let id = team.value["Team Id"] as? String,
                    let name = team.value["Team Name"] as? String
                    else { return }
                let team = TeamDB(teamId: id, teamName: name)
                self.addTeamToRealm(teamDB: team)
            }
        })
    }
}
