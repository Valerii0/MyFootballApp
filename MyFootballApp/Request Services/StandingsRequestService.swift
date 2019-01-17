//
//  StandingsRequestService.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 12/12/18.
//  Copyright © 2018 Valerii Petrychenko. All rights reserved.
//

import Foundation

class StandingsRequestService {

    func getStandings(leagueId: String, callBack: @escaping (_ standings: [Standings]?, _ error: Error?) -> Void) {

        var urlString = AppConstants.RequestsConstants.urlString
        urlString.append(AppConstants.RequestsConstants.competitions)
        urlString.append(leagueId + "/")
        urlString.append(AppConstants.RequestsConstants.standings)

        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [
            URLQueryItem(name: AppConstants.RequestsConstants.planName, value: AppConstants.RequestsConstants.planValue),
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
                        let standings = json["standings"] as? [[String: Any]]
                        else { return }

                    var listOfStandings = [Standings]()

                    for eachStandings in standings {
                        if let item = Standings.init(json: eachStandings) {
                            listOfStandings.append(item)
                        }
                    }

                    callBack(listOfStandings, nil)

                } catch {
                    print(error.localizedDescription)
                    callBack(nil, error)
                }
            }
        }
        task.resume()
    }
}
