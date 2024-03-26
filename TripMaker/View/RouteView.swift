//
//  RouteView.swift
//  TripMaker
//
//  Created by Megan Lin on 3/20/24.
//

import SwiftUI

struct RouteView: View {
    @State var route: String
    @State var image: Image?
    @State var routeDetail: Route?
    @State var locations: [String] = []
    
    var body: some View {
        List {
            ForEach(locations, id: \.self)
            { location in
                NavigationLink {
                    LocationView(location: location)
                } label: {
                    LocationRowView(location: location)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                let db = DBManager.shared
                do {
                    self.routeDetail = try db.fetchRouteDetails(route: route)
                    self.locations = self.routeDetail?.locationNames ?? []
                } catch {
                    print("Route View Database operation failed: \(error)")
                }
            }
        }
    }
}

#Preview {
    RouteView(route: "Taiwan")
}
