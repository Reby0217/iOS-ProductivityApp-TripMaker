//
//  ContentView.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-16.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var routes: [UUID] = initData()
    
    @State var presentSideMenu = false
    @State var selectedSideMenuTab = 0
    
    
    var body: some View {
        ZStack{
            TabView(selection: $selectedSideMenuTab) {
                MapView(presentSideMenu: $presentSideMenu)
                    .tag(0)
                StatsView(presentSideMenu: $presentSideMenu)
                    .tag(1)
                ProfileView(presentSideMenu: $presentSideMenu)
                    .tag(2)
                PassportView(presentSideMenu: $presentSideMenu)
                    .tag(3)
                RankingView(presentSideMenu: $presentSideMenu)
                    .tag(4)
            }
            
            SideMenu(isShowing: $presentSideMenu, content: AnyView(SideMenuView(selectedTab: $selectedSideMenuTab, showSideMenu: $presentSideMenu)))
        }
    }
    
    

//    var body: some View {
//        NavigationSplitView {
//            List {
//                ForEach(routes, id: \.self)
//                { route in
//                    NavigationLink {
//                        RouteView(routeID: route)
//                    } label: {
//                        RouteRowView(routeID: route)
//                    }
//                }
//            }
//        } detail: {
//            Text("Passport")
//        }
//        .onAppear{
//            print("refresh")
//        }
//    }
}

func initData() -> [UUID] {
    var routes: [UUID] = []
    
    print("called")
    let db = DBManager.shared
    do {
        routes = try db.fetchAllRoutes()
        print(routes)
    } catch {
        print("Database operation failed: \(error)")
    }
    return routes
}

#Preview {
    ContentView()
}
