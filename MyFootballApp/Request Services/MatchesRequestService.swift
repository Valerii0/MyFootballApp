//
//  MatchesRequestService.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 12/3/18.
//  Copyright © 2018 Valerii Petrychenko. All rights reserved.
//

import Foundation

class MatchesRequestService {

    func getTodayMatchByTeam(teamId: String, dateFrom: String, dateTo: String, callBack: @escaping (_ matches: [Match]?, _ error: Error?) -> Void) {

        var urlString = AppConstants.RequestsConstants.urlString
        urlString.append(AppConstants.RequestsConstants.teams)
        urlString.append(teamId + "/")
        urlString.append(AppConstants.RequestsConstants.matches)

        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [
            URLQueryItem(name: AppConstants.RequestsConstants.planName, value: AppConstants.RequestsConstants.planValue),
            URLQueryItem(name: AppConstants.RequestsConstants.dateFrom, value: dateFrom),
            URLQueryItem(name: AppConstants.RequestsConstants.dateTo, value: dateTo)
        ]

        var request = URLRequest(url: (urlComponents?.url)!)
        request.setValue(AppConstants.RequestsConstants.keyForFreePlanValue, forHTTPHeaderField: AppConstants.RequestsConstants.keyForFreePlanName)

        getMatches(request: request, callBack: callBack)
    }

    func getMatchesByTeam(teamId: String, callBack: @escaping (_ matches: [Match]?, _ error: Error?) -> Void) {

        var urlString = AppConstants.RequestsConstants.urlString
        urlString.append(AppConstants.RequestsConstants.teams)
        urlString.append(teamId + "/")
        urlString.append(AppConstants.RequestsConstants.matches)

        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [
            URLQueryItem(name: AppConstants.RequestsConstants.planName, value: AppConstants.RequestsConstants.planValue)
        ]

        var request = URLRequest(url: (urlComponents?.url)!)
        request.setValue(AppConstants.RequestsConstants.keyForFreePlanValue, forHTTPHeaderField: AppConstants.RequestsConstants.keyForFreePlanName)

        getMatches(request: request, callBack: callBack)
    }

    func getMatchesByDate(dateFrom: String, dateTo: String, callBack: @escaping (_ matches: [Match]?, _ error: Error?) -> Void) {

        var urlString = AppConstants.RequestsConstants.urlString
        urlString.append(AppConstants.RequestsConstants.matches)

        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [
            URLQueryItem(name: AppConstants.RequestsConstants.planName, value: AppConstants.RequestsConstants.planValue),
            URLQueryItem(name: AppConstants.RequestsConstants.dateFrom, value: dateFrom),
            URLQueryItem(name: AppConstants.RequestsConstants.dateTo, value: dateTo)
        ]

        var request = URLRequest(url: (urlComponents?.url)!)
        request.setValue(AppConstants.RequestsConstants.keyForFreePlanValue, forHTTPHeaderField: AppConstants.RequestsConstants.keyForFreePlanName)

        getMatches(request: request, callBack: callBack)
    }

    func getMatches(request: URLRequest, callBack: @escaping (_ matches: [Match]?, _ error: Error?) -> Void) {

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let responseError = error {
                print(responseError.localizedDescription)
                callBack(nil, responseError)
            } else if let responseData = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                        let matches = json["matches"] as? [[String: Any]]
                        else { return }

                    var listOfMatches = [Match]()

                    for match in matches {
                        if let item = Match.init(json: match) {
                            listOfMatches.append(item)
                        }
                    }

                    callBack(listOfMatches, nil)

                } catch {
                    print(error.localizedDescription)
                    callBack(nil, error)
                }
            }
        }
        task.resume()
    }
}
