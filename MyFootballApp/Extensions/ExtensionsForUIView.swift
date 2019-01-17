//
//  ExtensionsForUIView.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 12/18/18.
//  Copyright © 2018 Valerii Petrychenko. All rights reserved.
//

import Foundation
import UIKit
import Macaw

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }

    func brokenImage(contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        DispatchQueue.main.async {
            if let image = UIImage(named: "brokenImage") {
                let imageView = UIImageView(image: image)
                imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                imageView.contentMode = mode
                self.addSubview(imageView)
            }
        }
    }

    func dowloadFromServerUrl(url: URL, imageCach: NSCache<NSString, UIView>?, link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        DispatchQueue.global(qos: .background).async {
            do {
                let text = try String(contentsOf: url)
                DispatchQueue.main.async {
                    do {
                        let node = try SVGParser.parse(text: text)
                        let mapView: MacawView = SVGView(node: node, frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
                        mapView.backgroundColor = UIColor.white
                        mapView.contentMode = mode
                        imageCach?.setObject(mapView, forKey: NSString(string: link))
                        self.addSubview(mapView)
                    } catch {
                        print("svgParser err")
                        self.brokenImage()
                    }
                }
            } catch {
                print(url)
                self.brokenImage()
            }
        }
    }

    func dowloadFromServer(link: String, imageCach: NSCache<NSString, UIView>?, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { brokenImage(); return }
        do {
            let data = try Data.init(contentsOf: url)
            if let image = UIImage.init(data: data) {
                DispatchQueue.main.async() {
                    let imageView = UIImageView(image: image)
                    imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                    imageView.backgroundColor = UIColor.white
                    imageView.contentMode = mode
                    imageCach?.setObject(imageView, forKey: NSString(string: link))
                    self.addSubview(imageView)
                }
            } else {
                dowloadFromServerUrl(url: url, imageCach: imageCach, link: link, contentMode: mode)
            }
        } catch {
            print("wrong url - " + "\(url)")
            brokenImage()
        }
    }
}
