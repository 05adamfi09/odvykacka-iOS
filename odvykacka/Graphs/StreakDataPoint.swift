//
//  StreakDataPoint.swift
//  odvykacka
//
//  Created by Filip Adámek on 25.06.2023.
//

import Foundation

struct StreakDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let streakCount: Int
}
