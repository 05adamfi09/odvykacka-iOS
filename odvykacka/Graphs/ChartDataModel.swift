//
//  ChartDataModel.swift
//  odvykacka
//
//  Created by Filip Adámek on 21.06.2023.
//

import Foundation
import SwiftUI

final class ChartDataModel: ObservableObject {
    var chartCellModel: [ChartCellModel]
    var startingAngle = Angle(degrees: 0)
    private var lastBarEndAngle = Angle(degrees: 0)
     
         
    init(dataModel: [ChartCellModel]) {
        chartCellModel = dataModel
    }
     
    var totalValue: CGFloat {
        chartCellModel.reduce(CGFloat(0)) { (result, data) -> CGFloat in
            result + data.value
        }
    }
     
    func angle(for value: CGFloat) -> Angle {
        if startingAngle != lastBarEndAngle {
            startingAngle = lastBarEndAngle
        }
        lastBarEndAngle += Angle(degrees: Double(value / totalValue) * 360 )
        //print(lastBarEndAngle.degrees)
        return lastBarEndAngle
    }
}

struct ChartCellModel: Identifiable {
    let id = UUID()
    let color: Color
    let value: CGFloat
    let name: String
}
