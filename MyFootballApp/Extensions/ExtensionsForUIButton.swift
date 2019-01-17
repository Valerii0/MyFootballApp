//
//  ExtensionsForUIButton.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 1/7/19.
//  Copyright © 2019 Valerii Petrychenko. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {

    func buttonPressEffect() {
        UIButton.animate(withDuration: 0.2, animations: {
                            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        },
                         completion: { finish in
                            UIButton.animate(withDuration: 0.2, animations: {
                                self.transform = CGAffineTransform.identity
                            })
        })
    }
}
