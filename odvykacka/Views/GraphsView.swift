//
//  GraphsView.swift
//  odvykacka
//
//  Created by Filip Adámek on 29.05.2023.
//

import SwiftUI
import Charts
import Foundation
import AnimatedNumber

struct GraphsView: View {
    
    @StateObject var viewModel: MainViewModel
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var logs: FetchedResults<DayLog>
    
    
    @State var value: Double = 0
    
    func logsToLogsModel(){
        viewModel.convertToLogsModel(dayLog: logs)
    }
    
    @State var selectedPie: String = "Click on the pie"
    @State var selectedDonut: String = ""
    
    
    var body: some View {
        let sample = [ ChartCellModel(color: Color.green, value: viewModel.getSuccesDays(), name: "Succesfull days"),
                       ChartCellModel(color: Color.red, value: viewModel.getBadDays(), name: "Bad days"),
                       ChartCellModel(color: Color.blue, value: viewModel.getNotLoggedDays(), name: "Not logged days")]
        
        let streakDataPoints = viewModel.calculateStreakDataPoints()
        NavigationView {
            
            if(logs.isEmpty){
                VStack{
                    Text("No data")
                        .font(.title)
                    Image(uiImage: UIImage(named: "personal_graphs")!)
                        .resizable()
                        .scaledToFit()
                    
                }
            } else {
                
                VStack {
                    
                    //longest streak
                    HStack{
                        Text("Longest streak: ")
                        
                        AnimatedNumber($value, duration: 1.5)
                            .font(.largeTitle)
                        
                    }
                    
                    HStack(spacing: 20) {
                        PieChart(dataModel: ChartDataModel.init(dataModel: sample), onTap: {
                            dataModel in
                            if let dataModel = dataModel {
                                self.selectedPie = "\(dataModel.name)\nQuantity: " + String(Int(dataModel.value))
                            } else {
                                self.selectedPie = ""
                            }
                        })
                        .frame(width: 150, height: 150, alignment: .center)
                        .padding()
                        Text(selectedPie)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        
                    }
                    /*
                     HStack {
                     ForEach(sample) { dataSet in
                     VStack {
                     Circle()
                     .foregroundColor(dataSet.color)
                     .frame(width: 50, height: 50)
                     Text(dataSet.name).font(.footnote)
                     }
                     }
                     }
                     */
                    
                    
                    
                    
                    Text("Streak history:")
                    
                    Chart{
                        ForEach(streakDataPoints, id: \.date) { item in
                            LineMark(x: .value("Date", item.date), y: .value("Streak", item.streakCount))
                        }
                    }.scaledToFit()
                        
                    
                    
                    
                    
                    
                }
            }
        }
                    
            .navigationTitle("Graphs")
            .onAppear(){
                logsToLogsModel()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                    value = Double(viewModel.getLongestStreak())
                }
            }
    }
                    
}
                    


