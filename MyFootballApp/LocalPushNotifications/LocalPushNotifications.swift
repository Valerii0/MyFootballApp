//
//  LocalPushNotifications.swift
//  MyFootballApp
//
//  Created by Valerii Petrychenko on 1/10/19.
//  Copyright © 2019 Valerii Petrychenko. All rights reserved.
//

import Foundation
import UserNotifications
import RealmSwift

class LocalPushNotifications: NSObject, UNUserNotificationCenterDelegate {

    struct Constants {
        static let defaultNotification = "defaultNotification"
        static let defaultNotificationTitle = "Hello!"
        static let defaultNotificationBody = "Just check my App"
        static let dateFormatForNotification = "h:mm a"
    }

    let notificationCenter = UNUserNotificationCenter.current()
    
    func notificationRequestAskPermission() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]

        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }

    func notificationCheck(completionHandler: @escaping (Bool) -> Void) {
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }

    func printAllScheduledNotification() {
        notificationCenter.getPendingNotificationRequests { (notificationRequests) in
            for notification: UNNotificationRequest in notificationRequests {
                print(notification.identifier)
                print(notification.content)
            }
        }
    }

    func deleteAllScheduledNotification() {
        notificationCenter.removeAllPendingNotificationRequests()
    }

    func deleteAllScheduledNotificationExceptDefault() {
        getPendingNotificationsExceptDefault { (identifiers) in
            self.notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }

    private func getPendingNotificationsExceptDefault(completionHandler: @escaping ([String]) -> Void) {
        notificationCenter.getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification: UNNotificationRequest in notificationRequests {
                if notification.identifier != Constants.defaultNotification {
                    identifiers.append(notification.identifier)
                }
            }
            completionHandler(identifiers)
        }
    }

    private func checkIsPendingDefaultNotification(completionHandler: @escaping (Bool) -> Void) {
        notificationCenter.getPendingNotificationRequests { (notificationRequests) in
            var check = false
            for notification: UNNotificationRequest in notificationRequests {
                if notification.identifier == Constants.defaultNotification {
                    check = true
                }
            }
            completionHandler(check)
        }
    }

    private func convertDate(currentDate: Date, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = dateFormat
        let returnDate = dateFormatter.string(from: currentDate)
        return returnDate
    }

    func checkAllTeamsMatchesForNotifications() {

        var teamsArrayForCreate = [TeamDB]()
        var identifiersForDelete = [String]()

        var teamsArray = [TeamDB]()
        do {
            let realm = try Realm()
            let teams = realm.objects(TeamDB.self)
            for team in teams {
                teamsArray.append(TeamDB(teamId: team.teamId, teamName: team.teamName))
            }
        } catch {
            print(error.localizedDescription)
        }

        getPendingNotificationsExceptDefault { (identifiers) in
            for team in teamsArray {
                if identifiers.filter( { $0 == team.teamId } ).first == nil {
                    teamsArrayForCreate.append(team)
                }
            }

            for identifier in identifiers {
                if teamsArray.filter( { $0.teamId == identifier } ).first == nil {
                    identifiersForDelete.append(identifier)
                }
            }

            self.notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)

            let dateFrom = self.convertDate(currentDate: Date(), dateFormat: AppConstants.RequestsConstants.dateFormat)
            let dateTo = self.convertDate(currentDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, dateFormat: AppConstants.RequestsConstants.dateFormat)

            for team in teamsArrayForCreate {
                MatchesRequestService().getTodayMatchByTeam(teamId: team.teamId, dateFrom: dateFrom, dateTo: dateTo) { (match, error) in
                    guard let match = match,
                        let firstMatch = match.first
                        else { return }

                    let title = team.teamName
                    let identifier = team.teamId
                    let homeTeamName = firstMatch.homeTeamName
                    let awayTeamName = firstMatch.awayTeamName
                    let date = self.convertDate(currentDate: firstMatch.utcDate,
                                                dateFormat: Constants.dateFormatForNotification)
                    let body = homeTeamName + " - " + awayTeamName + ", " + date

                    let dateForShow = firstMatch.utcDate.addingTimeInterval(-6 * 3600)
                    let day = Calendar.current.component(.day, from: dateForShow)
                    let hour = Calendar.current.component(.hour, from: dateForShow)
                    let minute = Calendar.current.component(.minute, from: dateForShow)

                    var dateComponents = DateComponents()
                    dateComponents.day = day
                    dateComponents.hour = hour
                    dateComponents.minute = minute
                    self.scheduleNotification(title: title, body: body, identifier: identifier, date: dateComponents)
                }
            }
        }

        checkIsPendingDefaultNotification { (check) in
            if !check {
                self.scheduleNotification(title: Constants.defaultNotificationTitle, body: Constants.defaultNotificationBody,
                                          identifier: Constants.defaultNotification, date: nil)
            }
        }
    }

    func scheduleNotification(title: String, body: String, identifier: String, date: DateComponents?) {

        let identifier = identifier

        let content = UNMutableNotificationContent()

        let userActions = "User Actions"
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = userActions

        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 10
        var trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        if let date = date {
            trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        }

        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }

        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])

        let category = UNNotificationCategory(identifier: userActions, actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])

        notificationCenter.setNotificationCategories([category])
    }


    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.alert, .sound, .badge])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        if response.notification.request.identifier == "Local Notification" {
            print("Handling notifications with the Local Notification Identifier")
        }

        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "Snooze":
            print("Snooze")
            //scheduleNotification(title: "Reminder", body: "Reminder")
        case "Delete":
            print("Delete")
        default:
            print("Unknown action")
        }

        completionHandler()
    }

}
