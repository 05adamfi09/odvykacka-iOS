//
//  ContentView.swift
//  odvykacka
//
//  Created by Filip Adámek on 08.05.2023.
//

import SwiftUI
import CoreData

struct MainView: View {
    
    @AppStorage("hasProfile") var hasProfile = false
    
    @StateObject var mainViewModel: MainViewModel
    
    @FetchRequest(sortDescriptors: []) var logs: FetchedResults<DayLog>

    
    @State private var isLogPresented: Bool = false
    @State private var isMotivationPresented: Bool = false
    
    
    
    
    var body: some View {
        
        if(!hasProfile){
            NewProfileView(ViewModel: mainViewModel)
            
        } else {
            
            NavigationView{
                
                VStack{
                    ZStack{
                        Circle()
                            .frame(width: 200, height: 200)
                            .foregroundColor(.orange)
                        Text(String(mainViewModel.cleanDays))
                            .foregroundColor(.white)
                            .font(.system(size: 70, weight: .bold))
                    }
                    
                    Text("Days without " + (mainViewModel.getFirstUser()?.addiction ?? "unknown"))
                        .font(.system(size: 20, weight: .bold))
                    
                    //log
                    
                    Button{
                        isLogPresented.toggle()
                    } label: {
                        Text("LOG DAY")
                            .bold()
                            .frame(width: 200, height: 50)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    /*
                     NavigationLink(destination: LogView(), label: {
                     Text("LOG DAY")
                     .bold()
                     .frame(width: 200, height: 50)
                     .background(Color.orange)
                     .foregroundColor(.white)
                     .cornerRadius(10)
                     })
                     */

                    Button{
                        isMotivationPresented.toggle()
                    } label: {
                        Text("MOTIVATION")
                            .bold()
                            .frame(width: 200, height: 50)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    //graph
                    NavigationLink(destination: GraphsView(viewModel: mainViewModel), label: {
                        Text("GRAPHS")
                            .bold()
                            .frame(width: 200, height: 50)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    })
                    
                    //list
                    NavigationLink(destination: ListView(viewModel: mainViewModel), label: {
                        Text("HISTORY")
                            .bold()
                            .frame(width: 200, height: 50)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    })
                    
                    //calendar
                    NavigationLink(destination: CalendarView(viewModel: mainViewModel), label: {
                        Text("CALENDAR")
                            .bold()
                            .frame(width: 200, height: 50)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    })
                    
                    
                    
                }
                .navigationTitle("Odvykačka")
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing){
                        NavigationLink(destination: SettingsView(viewModel: mainViewModel), label: {Text("Settings")})
                    }
                }
                .sheet(isPresented: $isLogPresented){
                    NewLogView(viewModel: mainViewModel, isLogPresented: $isLogPresented)
                        .presentationDetents([.fraction(0.25), .large])
                }
                .edgesIgnoringSafeArea(.bottom)
                
                .sheet(isPresented: $isMotivationPresented){
                    MotivationView(viewModel: mainViewModel, isPresented: $isMotivationPresented)
                        .presentationDetents([.medium, .height(mainViewModel.getUser()!.motivationPicture.size.height * mainViewModel.getUser()!.motivationPicture.scale)])

                }
                .onAppear(){
                    mainViewModel.convertToLogsModel(dayLog: logs)
                    mainViewModel.getCleanDays()
                    
                }
                
            }
            
        }
    }
    
    
    
}
