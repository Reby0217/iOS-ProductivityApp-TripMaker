//
//  RouteView.swift
//  TripMaker
//
//  Created by Megan Lin on 3/20/24.
//

import SwiftUI

struct RouteView: View {
    @State var routeID: UUID
    @State var image: Image?
    @State var routeDetail: Route?
    @State var locations: [UUID] = []
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(locations, id: \.self)
                { location in
                    NavigationLink {
                        LocationView(locationID: location)
                    } label: {
                        LocationRowView(locationID: location)
                    }
                }
            }
        } detail: {
            Text("Passport")
        }
        .onAppear {
            DispatchQueue.main.async {
                let db = DBManager.shared
                do {
                    self.routeDetail = try db.fetchRouteDetails(routeID: routeID)
                    self.locations = self.routeDetail?.locationArray ?? []
                } catch {
                    print("Database operation failed: \(error)")
                }
            }
        }
    }
}

#Preview {
    RouteView(routeID: UUID())
}
