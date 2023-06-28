//
//  ListView.swift
//  odvykacka
//
//  Created by Filip Adámek on 21.06.2023.
//

import SwiftUI

struct ListView: View {
    
    @StateObject var viewModel: MainViewModel
    
    //Jen zkouška, pak smazat
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var logs: FetchedResults<DayLog>
        
       
    func getDateFormat(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter.string(from: date)
        
    }
        
    func logsToLogsModel(){
        viewModel.convertToLogsModel(dayLog: logs)
    }

    
    
    
    var body: some View {
        
        NavigationView {
            
            
            if(viewModel.logs.isEmpty){
                VStack{
                    Text("No data")
                        .font(.title)
                    Image(uiImage: UIImage(named: "empty_cart")!)
                        .resizable()
                        .scaledToFit()
                }
            } else{
                List{
                    ForEach(viewModel.logs.sorted{ $0.date > $1.date }){ log in
                        VStack(alignment: .leading){
                            Text("Date: \(getDateFormat(date: log.date))")
                            Text("Succes: \(String(log.succes))")
                        }
                        
                    }
                    .onDelete(perform: viewModel.deleteLog(at:))
                
                }
                
                
            }
         
                
        }
        .onAppear(){
            logsToLogsModel()
        }
        .navigationTitle("History logs")
            
    }
}

