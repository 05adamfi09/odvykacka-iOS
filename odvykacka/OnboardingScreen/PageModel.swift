//
//  PageModel.swift
//  odvykacka
//
//  Created by Filip Adámek on 20.06.2023.
//

import Foundation

struct Page: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var description: String
    var imageUrl: String
    var tag: Int
    
    static var samplePage = Page(name: "Title example", description: "This is a sample", imageUrl: "breaking_barriers", tag: 0)
    
    static var samplePages: [Page] = [
    Page(name: "Welcome in Odvykačka App!", description: "This app will help you to handle with your bad habbit", imageUrl: "breaking_barriers", tag: 0),
    Page(name: "Stay motivated in your rehab!", description: "This app will help you in the worsed moments", imageUrl: "regain_focus", tag: 1),
    Page(name: "You will see your progress", description: "In the app you can find graphs and counter of your current rehab streak", imageUrl: "personal_graphs", tag: 2)
    ]
}
