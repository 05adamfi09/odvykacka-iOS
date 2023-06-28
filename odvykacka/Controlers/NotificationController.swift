//
//  ViewController.swift
//  odvykacka
//
//  Created by Filip Adámek on 31.05.2023.
//

import Foundation
import UIKit

class NotificationController: UIViewController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    func chechForPermission(){
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings{ settings in
            switch settings.authorizationStatus {
            case .authorized:
                self.dispatchNotification()
            case .denied:
                return
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]){ didAllow, error in
                    if didAllow {
                        self.dispatchNotification()
                    }
                }
            default:
                return
            }
        }
        
        
    }
    
    func dispatchNotification(){
        
        let identifier = "remember-log"
        let title = "Don't forget log today!"
        let body = "How are you feeling today?"
        let hour = 15
        let minute = 23
        let isDaily = true
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let calendar = Calendar.current
        var dataComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        dataComponents.hour = hour
        dataComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dataComponents, repeats: isDaily)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request)
    }
    
    
    
}
