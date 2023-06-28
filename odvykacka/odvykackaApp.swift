//
//  odvykackaApp.swift
//  odvykacka
//
//  Created by Filip Adámek on 08.05.2023.
//

import SwiftUI

@main
struct odvykackaApp: App {
    
    @StateObject private var dataController = CoreDataController()

    var body: some Scene {
        WindowGroup {

            ContentView(mainViewModel: MainViewModel(moc: dataController.container.viewContext), notificationController: NotificationController()).environment(\.managedObjectContext, dataController.container.viewContext)
             
        }
    }
}
