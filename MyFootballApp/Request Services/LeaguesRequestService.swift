//
//  LeaguesRequestService.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 11/30/18.
//  Copyright © 2018 Valerii Petrychenko. All rights reserved.
//

import Foundation

class LeaguesRequestService {

    func getLeagues(callBack: @escaping (_ leagues: [League]?, _ error: Error?) -> Void) {

        var urlString = AppConstants.RequestsConstants.urlString
        urlString.append(AppConstants.RequestsConstants.competitions)

        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [
            URLQueryItem(name: AppConstants.RequestsConstants.planName, value: AppConstants.RequestsConstants.planValue)
        ]

        var request = URLRequest(url: (urlComponents?.url)!)
        request.setValue(AppConstants.RequestsConstants.keyForFreePlanValue, forHTTPHeaderField: AppConstants.RequestsConstants.keyForFreePlanName)

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let responseError = error {
                print(responseError.localizedDescription)
                callBack(nil, responseError)
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

                    callBack(listOfLeagues, nil)

                } catch {
                    print(error.localizedDescription)
                    callBack(nil, error)
                }
            }

        }
        task.resume()
    }
}
