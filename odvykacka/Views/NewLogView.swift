//
//  LogView.swift
//  odvykacka
//
//  Created by Filip Adámek on 29.05.2023.
//

import SwiftUI

struct NewLogView: View {
    
    @StateObject var viewModel: MainViewModel
    
    @Binding var isLogPresented: Bool
    
    @State var date: Date = Date()
    @State var succesfullDay = true
    
    @State var isFutureAlertPresented = false
    @State  var todayWasLoggedAllertPresented: Bool = false
    
    @State var isTodayLogged: Bool = false

    @FetchRequest(sortDescriptors: []) var logs: FetchedResults<DayLog>
    
    
    var body: some View {
        NavigationView{
            
            ScrollView{
                VStack{
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    
                    Picker("Did you keep your streak?", selection: $succesfullDay){
                        Text("Successful day").tag(true)
                        Text("Bad day").tag(false)
                    }.pickerStyle(.segmented)
                    
                }
            }
            .navigationTitle("Log day")
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarLeading){
                    Button("Close"){
                        isLogPresented.toggle()
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    Button("Save"){
                        let calendar = Calendar.current
                        let currentDate = calendar.startOfDay(for: Date())
                        let pickedDateWithoutTime = calendar.startOfDay(for: date)
                        if (pickedDateWithoutTime > currentDate){
                            isFutureAlertPresented.toggle()
                        } else {
                            isTodayLogged = viewModel.isDayAlreadyLoggedFcn(pickedDate: date)
                            if isTodayLogged == true {
                                todayWasLoggedAllertPresented.toggle()
                            } else {
                                let newLog = LogModel(id: UUID(), date: date, succes: succesfullDay)
                                
                                viewModel.saveLog(log: newLog)
                                viewModel.convertToLogsModel(dayLog: logs)
                                viewModel.getCleanDays()
                                isLogPresented.toggle()
                            }
                        }
                    }
                    .alert(isPresented: $todayWasLoggedAllertPresented){
                        Alert(title: Text("This day is already logged"), dismissButton: .default(Text("Got it!")))
                    }
                }
            }
            .alert(isPresented: $isFutureAlertPresented){
                Alert(title: Text("You can't log to the future!"), dismissButton: .default(Text("Got it!")))
            }
              
            
        }
    }
}

/*
 struct LogView_Previews: PreviewProvider {
 static var previews: some View {
 LogView()
 }
 }
 */
