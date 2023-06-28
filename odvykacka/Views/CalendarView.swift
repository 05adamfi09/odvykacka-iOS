//
//  CalendarView.swift
//  odvykacka
//
//  Created by Filip Adámek on 21.06.2023.
//

import SwiftUI
import FSCalendar

struct CalendarView: View {
    @StateObject var viewModel: MainViewModel
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var logs: FetchedResults<DayLog>
    
    
    @State var value: Double = 0
    
    func logsToLogsModel(){
        viewModel.convertToLogsModel(dayLog: logs)
    }
    
    
    var body: some View {
        
        
        NavigationView {
            
            CalendarViewRepresentable(goodDates: viewModel.getSuccesfullDays(), badDates: viewModel.getBadDays())

            
        }
        
        .navigationTitle("Calendar")
        .onAppear(){
            logsToLogsModel()
        }
        
    }
}

struct CalendarViewRepresentable: UIViewRepresentable {
    typealias UIViewType = FSCalendar
        
    fileprivate var calendar = FSCalendar()
    fileprivate var goodDates: [Date]
    fileprivate var badDates: [Date]

    @Environment(\.colorScheme) var colorScheme


    init(goodDates: [Date], badDates: [Date]) {
        self.goodDates = goodDates.compactMap { date in
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: date)
            return calendar.date(from: components)
        }
        self.badDates = badDates.compactMap { date in
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: date)
            return calendar.date(from: components)
        }
    }
    
    func makeUIView(context: Context) -> FSCalendar {
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        
        if colorScheme == .dark{
            calendar.appearance.titleDefaultColor = .white
            calendar.appearance.titleSelectionColor = .white
            calendar.appearance.headerTitleColor = .white
        } else {
            calendar.appearance.titleSelectionColor = .black
        }
        calendar.appearance.todayColor = UIColor.orange
        calendar.appearance.titleTodayColor = .white
        calendar.appearance.selectionColor = nil
        
        return calendar
        
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }


    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        var parent: CalendarViewRepresentable
        
        
        init(_ parent: CalendarViewRepresentable) {
            self.parent = parent
        }
        
        func calendar(_ calendar: FSCalendar,
                      imageFor date: Date) -> UIImage? {
            print(parent.goodDates)
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: date)
            let targetDate = calendar.date(from: components)
            
            if let targetDate = targetDate, parent.goodDates.contains(targetDate) {
                return UIImage(systemName: "checkmark.seal")
            } else if let targetDate = targetDate, parent.badDates.contains(targetDate){
                return UIImage(systemName: "xmark.seal")
            }
            return nil
            
        }
        
        
    }
}

