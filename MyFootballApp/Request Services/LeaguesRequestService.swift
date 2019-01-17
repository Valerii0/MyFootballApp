//
//  LeaguesRequestService.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 11/30/18.
//  Copyright © 2018 Valerii Petrychenko. All rights reserved.
//

import Foundation

class LeaguesRequestService {

    //static let shared = LeaguesRequestService()

    func getLeagues(callBack: @escaping (_ leagues: [League]) -> Void) {

        var urlString = AppConstants.urlString
        urlString.append(AppConstants.competitions)

        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [
            URLQueryItem(name: AppConstants.planName, value: AppConstants.planValue)
        ]

        var request = URLRequest(url: (urlComponents?.url)!)
        //request.httpMethod = "GET"
        request.setValue(AppConstants.keyForFreePlanValue, forHTTPHeaderField: AppConstants.keyForFreePlanName)

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let responseError = error {
                print(responseError.localizedDescription)
            } else if let responseData = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                    let leagues = json["competitions"] as? [[String: Any]]
                        else { return }

                    var listOfLeagues = [League]()

                    for league in leagues {
                        if let item = League.init(json: league) {
                            listOfLeagues.append(item)
                        }
                    }

                    callBack(listOfLeagues)

                } catch {
                    print(error.localizedDescription)
                }
            }

        }
        task.resume()
    }
}
