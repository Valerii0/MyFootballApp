//
//  SignUpViewController.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 1/4/19.
//  Copyright © 2019 Valerii Petrychenko. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    private struct Constants {
        static let titleAlert = "Password Incorrect"
        static let messageAlert = "Please re-type password"
    }

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reTypePasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        sender.buttonPressEffect()
        
        if passwordTextField.text != reTypePasswordTextField.text {
            showAlert(title: Constants.titleAlert, message: Constants.messageAlert)
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error == nil {
                    let mainTabBAr = UIStoryboard.init(name: AppConstants.NavigationConstants.storyboard, bundle: nil).instantiateViewController(withIdentifier: AppConstants.NavigationConstants.identifierForMainTabBar)
                    self.present(mainTabBAr, animated: true)
                } else {
                    self.showAlert(title: "Error", message: (error?.localizedDescription)!)
                }
            }
        }
    }
}
