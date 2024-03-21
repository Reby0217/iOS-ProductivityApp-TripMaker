//
//  PassportView.swift
//  TripMaker
//
//  Created by Megan Lin on 3/20/24.
//

import SwiftUI

struct PassportView: View {
    @State var routes: [UUID] = []
    
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
        .onAppear {
            print("passport view")
            DispatchQueue.main.async {
                let db = DBManager.shared
                do {
                    self.routes = try db.fetchAllRoutes()
                } catch {
                    print("Database operation failed: \(error)")
                }
            }
        }
    }
}

#Preview {
    PassportView()
}
