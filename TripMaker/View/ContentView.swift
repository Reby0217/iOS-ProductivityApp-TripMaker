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

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(routes, id: \.self)
                { route in
                    NavigationLink {
                        RouteView(routeID: route)
                    } label: {
                        RouteRowView(routeID: route)
                    }
                }
            }
        } detail: {
            Text("Passport")
        }
        .onAppear{
            print("refresh")
        }
    }
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
