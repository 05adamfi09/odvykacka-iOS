//
//  ContentView.swift
//  odvykacka
//
//  Created by Filip Adámek on 31.05.2023.
//

import SwiftUI

struct ContentView: View {
    @State var isActiveSplash : Bool = true

    
    @State private var pageIndex = 0
    private let pages: [Page] = Page.samplePages
    private let dotAppereance = UIPageControl.appearance()
    @AppStorage("isOnboarding") var isOnboarding = true
    
    @StateObject var mainViewModel: MainViewModel
    @State var notificationController: NotificationController
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var logs: FetchedResults<DayLog>
    
    var body: some View {
        if (isActiveSplash){
            SplashScreenView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            isActiveSplash = false
                        }
                    }
                }
            
        } else {
            if(isOnboarding){
                
                TabView(selection: $pageIndex){
                    ForEach(pages) { page in
                        VStack{
                            Spacer()
                            PageView(page: page)
                            Spacer()
                            if page == pages.last {
                                Button("Start") {
                                    isOnboarding = false
                                }
                                .buttonStyle(.bordered)
                            } else {
                                Button("next"){
                                    incrementPage()
                                }
                            }
                            Spacer()
                        }
                        .tag(page.tag)
                    }
                }
                .animation(.easeInOut, value: pageIndex)
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                .onAppear{
                    dotAppereance.currentPageIndicatorTintColor = .orange
                    dotAppereance.pageIndicatorTintColor = .gray
                }
                
            } else {
                MainView(mainViewModel: mainViewModel)
                
                    .onAppear(){
                        notificationController.chechForPermission()
                        notificationController.dispatchNotification()
                        mainViewModel.convertToLogsModel(dayLog: logs)
                        mainViewModel.getCleanDays()
                    }
            }
        }
    }
    func incrementPage(){
        pageIndex += 1
    }
    
    
}


