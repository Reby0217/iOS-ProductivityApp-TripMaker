//
//  RouteRowView.swift
//  TripMaker
//
//  Created by Megan Lin on 3/20/24.
//

import SwiftUI

struct RouteRowView: View {
    @State var routeID: UUID
    @State var routeDetail: Route?
    
    var body: some View {
        Text(routeDetail?.name ?? "")
        
        .onAppear {
            DispatchQueue.main.async {
                let db = DBManager.shared
                do {
                    self.routeDetail = try db.fetchRouteDetails(routeID: routeID)
                } catch {
                    print("Database operation failed: \(error)")
                }
            }
        }
    }
}

#Preview {
    RouteRowView(routeID: UUID())
}
