//
//  dataModel.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-17.
//

import UIKit
import Foundation
import SQLite
import Combine


class DBManager {
    
    static let shared = DBManager()
    
    var db: Connection?
    var iCloudURL: URL?

    let routeTable = RouteTable()
    let locationTable = LocationTable()
    let tagTable = TagTable()
    let rewardTable = RewardTable()
    let focusSessionTable = FocusSessionTable()
    let locationVisitedTable = LocationVisitedTable()
    let userProfileTable = UserProfileTable()
    let userRouteTable = UserRouteTable()
    let userRewardTable = UserRewardTable()

    private init() {
        Task {
            try await setupDatabase()
            fetchInfoFromApi()
        }
    }

    private func setupDatabase() async throws {
        let fileManager = FileManager.default
        guard let cloudURL = fileManager.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else {
            print("Unable to access iCloud Account")
            return
        }
        let dbURL = cloudURL.appendingPathComponent("db.sqlite3")
        self.iCloudURL = dbURL
        do {
            if !fileManager.fileExists(atPath: dbURL.path) {
                // Create it and insert initial data
                try await initializeDatabase(at: dbURL)
            } else {
                // Just connect to it
                connectToExistingDatabase(at: dbURL)
            }
        } catch {
            print("Database setup failed: \(error)")
        }
        inspectAllTables()
    }

    private func initializeDatabase(at url: URL) async throws {
        do {
            db = try Connection(url.path)
            try createTables()
            print("Initialize database...")
            try await insertInitialData()
        } catch {
            print("Failed to initialize database: \(error)")
        }
    }

    private func connectToExistingDatabase(at url: URL) {
        do {
            // Initialize the SQLite connection
            db = try Connection(url.path)
        } catch {
            print("Failed to connect to existing database: \(error)")
        }
    }


    private func createTables() throws {
        try db?.run(routeTable.table.create(ifNotExists: true) { t in
            t.column(routeTable.name, primaryKey: true)
            t.column(routeTable.mapPicture)
        })

        try db?.run(locationTable.table.create(ifNotExists: true) { t in
            t.column(locationTable.index)
            t.column(locationTable.route)
            t.column(locationTable.name, primaryKey: true)
            t.column(locationTable.realPicture)
            t.column(locationTable.description)
            t.column(locationTable.isLocked)
            t.foreignKey(locationTable.route, references: routeTable.table, routeTable.name, delete: .cascade)
        })

        try db?.run(tagTable.table.create(ifNotExists: true) { t in
            t.column(tagTable.location)
            t.column(tagTable.tag, primaryKey: true)
            t.foreignKey(tagTable.location, references: locationTable.table, locationTable.name, delete: .cascade)
        })

        try db?.run(rewardTable.table.create(ifNotExists: true) { t in
            t.column(rewardTable.name, primaryKey: true)
            t.column(rewardTable.picture)
            t.column(rewardTable.isClaimed)
        })
        
        try db?.run(userProfileTable.table.create(ifNotExists: true) { t in
            t.column(userProfileTable.userID, primaryKey: true)
            t.column(userProfileTable.username)
            t.column(userProfileTable.image)
            t.column(userProfileTable.dayTotalTime)
            t.column(userProfileTable.weekTotalTime)
            t.column(userProfileTable.monthTotalTime)
            t.column(userProfileTable.yearTotalTime)
        })
        
        try db?.run(userRouteTable.table.create(ifNotExists: true) { t in
            t.column(userRouteTable.userID)
            t.column(userRouteTable.route)
            t.unique(userRouteTable.userID, userRouteTable.route)
            
            t.foreignKey(userRouteTable.userID, references: userProfileTable.table, userProfileTable.userID, delete: .cascade)
            t.foreignKey(userRouteTable.route, references: routeTable.table, routeTable.name, delete: .cascade)
        })
        
        try db?.run(userRewardTable.table.create(ifNotExists: true) { t in
            t.column(userRewardTable.userID)
            t.column(userRewardTable.reward)
            t.unique(userRewardTable.userID, userRewardTable.reward)
            
            t.foreignKey(userRewardTable.userID, references: userProfileTable.table, userProfileTable.userID, delete: .cascade)
            t.foreignKey(userRewardTable.reward, references: rewardTable.table, rewardTable.name, delete: .cascade)
        })
        
        try db?.run(focusSessionTable.table.create(ifNotExists: true) { t in
            t.column(focusSessionTable.focusSessionID, primaryKey: true)
            t.column(focusSessionTable.userID)
            t.column(focusSessionTable.startTime)
            t.column(focusSessionTable.endTime)
            t.foreignKey(focusSessionTable.userID, references: userProfileTable.table, userProfileTable.userID, delete: .cascade)
        })
        
        try db?.run(locationVisitedTable.table.create(ifNotExists: true) { t in
            t.column(locationVisitedTable.focusSessionID)
            t.column(locationVisitedTable.location)
            t.unique(locationVisitedTable.focusSessionID, locationVisitedTable.location)
            
            t.foreignKey(locationVisitedTable.focusSessionID, references: focusSessionTable.table, focusSessionTable.focusSessionID, delete: .cascade)
            t.foreignKey(locationVisitedTable.location, references: locationTable.table, locationTable.name, delete: .cascade)
        })
    }
 
    private func insertInitialData() async throws {
        guard let map_taiwan = UIImage(named: "Taiwan-route.jpg"),
              let map_korea = UIImage(named: "South Korea-route.jpg"),
              let profilePic = UIImage(named: "profilePic.jpg"),
              let rewardImage0 = UIImage(named: "reward.png"),
              let rewardImage1 = UIImage(named: "reward1.png"),
              let rewardImage2 = UIImage(named: "reward2.png"),
              let rewardImage3 = UIImage(named: "reward3.png"),
              let rewardImage4 = UIImage(named: "reward4.png") else {
            print("Failed to load initial images.")
            return
        }
        
        let mapTaiwanPictureString = stringFromImage(map_taiwan)
        let mapKoreaPictureString = stringFromImage(map_korea)
        let profilePicString = stringFromImage(profilePic)
        
        let rewardImageString = stringFromImage(rewardImage0)
        let secondRewardImageStr = stringFromImage(rewardImage1)
        let thirdRewardImageStr = stringFromImage(rewardImage2)
        let fourthRewardImageStr = stringFromImage(rewardImage3)
        let fifthRewardImageStr = stringFromImage(rewardImage4)
        
        try addRoute(name: "Taiwan", mapPicture: mapTaiwanPictureString)
        try addRoute(name: "South Korea", mapPicture: mapKoreaPictureString)
        
        try addLocationToRoute(index: 1, routeName: "Taiwan", name: "Bangka Lungshan Temple", realPicture: "", description: "", isLocked: true)
        try addLocationToRoute(index: 2, routeName: "Taiwan", name: "National Taichung Theater", realPicture: "", description: "", isLocked: true)
        try addLocationToRoute(index: 3, routeName: "Taiwan", name: "Jiufen", realPicture: "", description: "", isLocked: true)
        try addLocationToRoute(index: 4, routeName: "Taiwan", name: "Taipei 101", realPicture: "", description: "", isLocked: true)
        try addLocationToRoute(index: 5, routeName: "Taiwan", name: "Formosa Boulevard metro station", realPicture: "", description: "", isLocked: true)
        try addLocationToRoute(index: 6, routeName: "Taiwan", name: "Fo Guang Shan Buddha Museum", realPicture: "", description: "", isLocked: true)
        try addLocationToRoute(index: 7, routeName: "Taiwan", name: "Yehliu", realPicture: "", description: "", isLocked: true)
        try addLocationToRoute(index: 8, routeName: "Taiwan", name: "Chiang Kai-shek Memorial Hall", realPicture: "", description: "", isLocked: true)
        
        try addLocationToRoute(index: 1, routeName: "South Korea", name: "Gyeongbokgung Palace", realPicture: "", description: "", isLocked: true)
        try addLocationToRoute(index: 2, routeName: "South Korea", name: "Myeong-dong", realPicture: "", description: "", isLocked: true)
        try addLocationToRoute(index: 3, routeName: "South Korea", name: "N Seoul Tower", realPicture: "", description: "", isLocked: true)
        try addLocationToRoute(index: 4, routeName: "South Korea", name: "Bukchon Hanok Village", realPicture: "", description: "", isLocked: true)
        try addLocationToRoute(index: 5, routeName: "South Korea", name: "Cheonggyecheon", realPicture: "", description: "", isLocked: true)
        try addLocationToRoute(index: 6, routeName: "South Korea", name: "Haedong Yonggungsa", realPicture: "", description: "", isLocked: true)
        try addLocationToRoute(index: 7, routeName: "South Korea", name: "Gamcheon Culture Village", realPicture: "", description: "", isLocked: true)
        
        try addTagToLocation(name: "Bangka Lungshan Temple", tag: "#ReligiousSite")
        try addTagToLocation(name: "Bangka Lungshan Temple", tag: "#CulturalHeritage")
        try addTagToLocation(name: "National Taichung Theater", tag: "#ArchitecturalWonder")
        try addTagToLocation(name: "National Taichung Theater", tag: "#ArtandCulture")
        try addTagToLocation(name: "Jiufen", tag: "#OldStreet")
        try addTagToLocation(name: "Jiufen", tag: "#HistoricalSite")
        try addTagToLocation(name: "Taipei 101", tag: "#EngineeringMarvel")
        try addTagToLocation(name: "Taipei 101", tag: "#CulturalHub")
        try addTagToLocation(name: "Formosa Boulevard metro station", tag: "#DomeofLight")
        try addTagToLocation(name: "Formosa Boulevard metro station", tag: "#ArtInstallation")
        try addTagToLocation(name: "Fo Guang Shan Buddha Museum", tag: "#Buddhism")
        try addTagToLocation(name: "Fo Guang Shan Buddha Museum", tag: "#SpiritualJourney")
        try addTagToLocation(name: "Yehliu", tag: "#Queen'sHead")
        try addTagToLocation(name: "Yehliu", tag: "#NaturalWonder")
        try addTagToLocation(name: "Chiang Kai-shek Memorial Hall", tag: "#Monument")
        try addTagToLocation(name: "Chiang Kai-shek Memorial Hall", tag: "#NationalPride")
        
        try addTagToLocation(name: "Gyeongbokgung Palace", tag: "#KoreanCulture")
        try addTagToLocation(name: "Gyeongbokgung Palace", tag: "#RoyalResidence")
        try addTagToLocation(name: "Myeong-dong", tag: "#ShoppingDistrict")
        try addTagToLocation(name: "Myeong-dong", tag: "#StreetFood")
        try addTagToLocation(name: "N Seoul Tower", tag: "#ObservationTower")
        try addTagToLocation(name: "N Seoul Tower", tag: "#SeoulSkyline")
        try addTagToLocation(name: "Bukchon Hanok Village", tag: "#HanokArchitecture")
        try addTagToLocation(name: "Bukchon Hanok Village", tag: "#TraditionalVillage")
        try addTagToLocation(name: "Cheonggyecheon", tag: "#SeoulStream")
        try addTagToLocation(name: "Cheonggyecheon", tag: "#UrbanRenewal")
        try addTagToLocation(name: "Haedong Yonggungsa", tag: "#SeasideTemple")
        try addTagToLocation(name: "Haedong Yonggungsa", tag: "#BusanLandmark")
        try addTagToLocation(name: "Gamcheon Culture Village", tag: "#ColorfulVillage")
        try addTagToLocation(name: "Gamcheon Culture Village", tag: "#StreetArt")

        
        
        try addTagToLocation(name: "Taipei 101", tag: "Engineering Marvel")
        try addTagToLocation(name: "Taipei 101", tag: "Cultural Hub")
        
        
        let userID = try createUserProfile(username: UserPreferences.userName, image: profilePicString)
        
        UserPreferences.userID = userID
        print("User ID is \(String(describing: UserPreferences.userID))")
        
        try addReward(name: "1st Reward", picture: rewardImageString)
        try addReward(name: "2nd Reward", picture: secondRewardImageStr)
        try addReward(name: "3rd Reward", picture: thirdRewardImageStr)
        try addReward(name: "4th Reward", picture: fourthRewardImageStr)
        try addReward(name: "5th Reward", picture: fifthRewardImageStr)
        
//        try claimReward(userID: userID, rewardName: "First Reward")
//        try claimReward(userID: userID, rewardName: "Second Reward")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDate = dateFormatter.string(from: Date())
            
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let sessionTimes = [
            ("2024-01-01 03:00:00", "2024-01-01 09:35:00"),
            ("2024-01-05 00:00:00", "2024-01-05 22:35:00"),
            ("2024-01-11 00:00:00", "2024-01-11 14:20:00"),
            //            ("2024-01-15 01:00:00", "2024-01-15 23:50:00"),
//            ("2024-04-01 10:15:00", "2024-04-01 12:45:00"),
//            ("2024-04-01 14:00:00", "2024-04-01 15:00:00"),
//            ("2024-04-02 11:00:00", "2024-04-02 12:00:00"),
//            ("2024-04-03 16:34:00", "2024-04-03 17:00:00"),
            ("2024-03-28 10:15:00", "2024-03-28 12:45:00"),
            ("\(todayDate) 00:00:00", "\(todayDate) 01:00:00"),
            ("\(todayDate) 02:00:00", "\(todayDate) 02:35:00"),
            ("\(todayDate) 11:00:00", "\(todayDate) 11:50:00"),
            ("\(todayDate) 16:00:00", "\(todayDate) 16:42:27")
        ]
        
        for (start, end) in sessionTimes {
            if let startTime = dateFormatter.date(from: start),
               let endTime = dateFormatter.date(from: end) {
                let _ = try createFocusSession(userID: userID, startTime: startTime, duration: endTime.timeIntervalSince(startTime))
            }
        }
    }
    
    func fetchInfoFromApi() {
        let url = urlTask()
        //var locations: [String] = []
        Task {
            do {
                let locations = try await fetchAllLocationsInOrder(routeName: "Taiwan")
                print("try to fetch location images")
                for location in locations {
                    url.fetchLocationDescription(for: location)
                    url.fetchLocationPicture(route: "Taiwan", for: location)
                }
            } catch {
                print("error fetching locations for Taiwan")
            }
            
            do {
                let locations = try await fetchAllLocationsInOrder(routeName: "South Korea")
                print("try to fetch location descriptions")
                for location in locations {
                    url.fetchLocationDescription(for: location)
                    url.fetchLocationPicture(route: "South Korea", for: location)
                }
            } catch {
                print("error fetching locations for South Korea")
            }
        }
        
    }
}
