//
//  CoreDataController.swift
//  odvykacka
//
//  Created by Filip Adámek on 29.05.2023.
//

import Foundation
import CoreData
class CoreDataController: ObservableObject{
    
    let container = NSPersistentContainer(name: "odvykacka")
    
    init(){
        container.loadPersistentStores{ description, error in
            if let error = error{
                print("Core data failed to load: \(error.localizedDescription)")
            }
            
        }
        
    }
}
