//
//  MainViewModel.swift
//  odvykacka
//
//  Created by Filip Adámek on 08.05.2023.
//

import SwiftUI
import Foundation
import CoreData


class MainViewModel: ObservableObject {
    @AppStorage("hasProfile") var hasProfile: Bool?

    
    @Published var logs: [LogModel] = []
    
    @Published var cleanDays: Int = 0
    
    
    var moc: NSManagedObjectContext
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    func getDayLog(with id: UUID) -> DayLog? {
        let request = DayLog.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let items = try? moc.fetch(request) else { return nil }
        print(items)
        return items.first
    }
    
    func deleteLog(at offsets: IndexSet){
        let sortedLogs = logs.sorted{ $0.date > $1.date }
        for offset in offsets {
            
            let log = sortedLogs[offset]
            
            if let deleteedLog = getDayLog(with: log.id){
                moc.delete(deleteedLog)
            }
            
        }
        save()
    }
    
    func calculateStreakDataPoints() -> [StreakDataPoint] {
        let calendar = Calendar.current
        var streakCount = 0
        var streakDataPoints: [StreakDataPoint] = []
        let sortedLogs = logs.sorted{ $0.date < $1.date }
        let finalList = sortedLogs.map{ log in
            let components = calendar.dateComponents([.year, .month, .day], from: log.date)
            let modifiedDate = calendar.date(from: components)!
            return LogModel(id: log.id, date: modifiedDate, succes: log.succes)
        }
        if !finalList.isEmpty {
            let firstDate = calendar.date(byAdding: .day, value: -1, to: finalList.first!.date)!
            streakDataPoints.append(StreakDataPoint(date: firstDate, streakCount: 0))
        }

        for log in finalList {
            if log.succes {
                streakCount += 1
            } else {
                streakCount = 0
            }

            let streakDataPoint = StreakDataPoint(date: log.date, streakCount: streakCount)
            streakDataPoints.append(streakDataPoint)
        }

        return streakDataPoints
    }
    
    
    func createProfile(profile: UserModel){
        deleteProfile()
        let newProfile = User(context: moc)
        newProfile.id = profile.id
        newProfile.addiction = profile.addiction
        newProfile.nickname = profile.nickname
        newProfile.profile_picture = profile.profilePicture.pngData()
        newProfile.motivation_picture = profile.motivationPicture.pngData()
        save()
        print("Profile has been saved")
    }
    
    func deleteProfile() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try moc.execute(deleteRequest)
            save()
            print("Profile has been deleted")
        } catch {
            print("Error deleting profile: \(error)")
        }
        hasProfile = false
        deleteAllLogs()
    }
    
    func getSuccesfullDays() -> [Date]{
        var dates: [Date] = []
        for log in logs {
            if (log.succes ){
                dates.append(log.date)
            }
        }
        return dates
    }
    
    func getBadDays() -> [Date]{
        var dates: [Date] = []
        for log in logs {
            if (!log.succes ){
                dates.append(log.date)
            }
        }
        return dates
    }
    
    func updateProfile(newProfilePicture: UIImage, newMotivationPicture: UIImage) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.fetchLimit = 1
            
        do {
            let result = try moc.fetch(fetchRequest)
            result.first!.profile_picture = newProfilePicture.pngData()
            result.first!.motivation_picture = newMotivationPicture.pngData()
            save()
        } catch {
            print("Error updating User profile picture: \(error)")
        }
        
    }
    
    func getFirstUser() -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.fetchLimit = 1

        do {
            let result = try moc.fetch(fetchRequest)
            return result.first
        } catch {
            print("Error fetching first user: \(error)")
            return nil
        }
    }
    
    func getSuccesDays() -> CGFloat{
        var succesDays: CGFloat = 0
        
        for log in logs {
            if (log.succes == true){
                succesDays += 1
            }
        }
        return succesDays
    }
    
    func getBadDays() -> CGFloat{
        var badDays: CGFloat = 0
        
        for log in logs {
            if (log.succes == false){
                badDays += 1
            }
        }
        return badDays
    }
    
    func getNotLoggedDays() -> CGFloat{
        let calendar = Calendar.current
        let sortedLogs = logs.sorted{ $0.date < $1.date }
        let dates = sortedLogs.map {log -> Date in
            let components = calendar.dateComponents([.year, .month, .day], from: log.date)
            return calendar.date(from: components)!
        }
        
        guard let firstDate = dates.first else {
            return 0
        }
        
        var uniqueDates = Set<DateComponents>()
        for date in dates {
            let components = calendar.dateComponents([.year, .month, .day], from: date)
            uniqueDates.insert(components)
        }
        
        let currentDate = Date()
        let startDate = calendar.startOfDay(for: firstDate)
        let endDate = calendar.startOfDay(for: currentDate)

        var missingDaysCount = 0
        var currentDateIterator = startDate
        while currentDateIterator <= endDate {
            let components = calendar.dateComponents([.year, .month, .day], from: currentDateIterator)
            if !uniqueDates.contains(components) {
                missingDaysCount += 1
            }
            currentDateIterator = calendar.date(byAdding: .day, value: 1, to: currentDateIterator)!
        }
        return CGFloat(missingDaysCount)
    }
    
    func saveLog(log: LogModel){
        let newLog = DayLog(context: moc)
        newLog.id = log.id
        newLog.date = log.date
        newLog.succes = log.succes
        save()
    }
    
    
    func convertToLogsModel(dayLog: FetchedResults<DayLog>) {
        logs = dayLog.map{
            let logID = $0.id
            let logDate = $0.date
            let logSucces = $0.succes
            
            
            return LogModel(id: logID ?? UUID(),
                            date: logDate ?? Date(),
                            succes: logSucces)
            
        }
    }
    
    func areDatesSame(date1: Date, date2: Date) -> Bool{
        let calendar = Calendar.current
            
        let components1 = calendar.dateComponents([.year, .month, .day], from: date1)
        let components2 = calendar.dateComponents([.year, .month, .day], from: date2)
        
        return components1.year == components2.year &&
               components1.month == components2.month &&
               components1.day == components2.day
    }
    
    func isDayAlreadyLoggedFcn(pickedDate: Date) -> Bool{
        for log in logs{
            if areDatesSame(date1: log.date, date2: pickedDate){
                print("This day is already logged")
                return true
            }
        }
        return false
        
    }
    
    /*
    func getAllLogs() -> [LogModel]{
        let fetchRequest: NSFetchRequest<DayLog> = DayLog.fetchRequest()
        
        do {
            let result = try moc.fetch(fetchRequest)
            logs = result.map{
                let logID = $0.id
                let logDate = $0.date
                let logSucces = $0.succes
                
                return LogModel(id: logID ?? UUID(),
                                date: logDate ?? Date(),
                                succes: logSucces)
            }
        } catch {
            print("Error fetching Logs: \(error)")
        }
        return logs
    }
     */
    
    
    
    private func save(){
        if moc.hasChanges {
            do {
                try moc.save()
            } catch  {
                print(error)
            }
        }
    }
    


    func getUser() -> UserModel? {
        var userModel: UserModel?
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        
        do {
            let result = try moc.fetch(fetchRequest)
            if let user = result.first,
               let motivationData = user.motivation_picture,
               let profileData = user.profile_picture,
               let motivationImage = UIImage(data: motivationData),
               let profileImage = UIImage(data: profileData) {
                userModel = UserModel(id: user.id ?? UUID(),
                                      nickname: user.nickname ?? "Unknown",
                                      addiction: user.addiction ?? "Unknown",
                                      profilePicture: profileImage,
                                      motivationPicture: motivationImage)
            }
        } catch {
            print("Error fetching User: \(error)")
        }
        
        return userModel
    }

    
    
    func getCleanDays(){
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var currentDate = Date()
        var clndays: Int = 0
        let sortedLogs = logs.sorted{ $0.date > $1.date }
        
        for log in sortedLogs {
            var logDate = dateFormatter.string(from: log.date)
            var curDate = dateFormatter.string(from: currentDate)
            print(logDate)
            print(curDate)
            print("_____")
            
            if logDate == curDate && log.succes == true{
                clndays = clndays + 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else{
                break
            }
        }
        print("Clean days has been counted, \(clndays)")
        cleanDays = clndays
        
    }
    
    func getLongestStreak() -> Int {
        var longestStreak = 0
        var currentStreak = 0
        let sortedLogs = logs.sorted{ $0.date < $1.date }
        
        var previousDate: Date?
            
            for log in sortedLogs {
                if log.succes {
                    let date = log.date
                    if let prevDate = previousDate {
                        // Check if the current date is consecutive with the previous date
                        if Calendar.current.isDate(date, inSameDayAs: prevDate.addingTimeInterval(24 * 60 * 60)) {
                            currentStreak += 1
                        } else {
                            currentStreak = 1
                        }
                    } else {
                        currentStreak = 1
                    }
                    
                    longestStreak = max(longestStreak, currentStreak)
                    previousDate = date
                } else {
                    previousDate = nil
                }
            }
            print("Longest streak is: \(longestStreak)")
            return longestStreak
          
          
          
    }
    
    func deleteAllLogs(){
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "DayLog")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try moc.execute(deleteRequest)
            save()
        } catch {
            print("Failed to delete DayLogs: \(error)")
        }
        
    }

    
}


