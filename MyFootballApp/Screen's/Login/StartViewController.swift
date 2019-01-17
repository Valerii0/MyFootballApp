//
//  StartViewController.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 1/4/19.
//  Copyright © 2019 Valerii Petrychenko. All rights reserved.
//

import UIKit
import Firebase

class StartViewController: UIViewController {

    private struct Constants {
        static let loginScreen = "LoginScreen"
        static let signUpScreen = "SignUpScreen"
    }

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser != nil {
            let mainTabBAr = UIStoryboard.init(name: AppConstants.NavigationConstants.storyboard, bundle: nil).instantiateViewController(withIdentifier: AppConstants.NavigationConstants.identifierForMainTabBar)
            self.present(mainTabBAr, animated: true)
        }
    }

    @IBAction func loginScreenAction(_ sender: UIButton) {
        sender.buttonPressEffect()
        performSegue(withIdentifier: Constants.loginScreen, sender: nil)
    }
    @IBAction func signUpAction(_ sender: UIButton) {
        sender.buttonPressEffect()
        performSegue(withIdentifier: Constants.signUpScreen, sender: nil)
    }
}
