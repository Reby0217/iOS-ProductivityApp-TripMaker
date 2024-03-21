//
//  TimerView.swift
//  TripMaker
//
//  Created by Megan Lin on 3/19/24.
//

import SwiftUI

struct TimerView: View {
    @State var routeName: String
    @State var image: Image?
    @State var routeID: UUID?
    
    
    var body: some View {
        VStack {
            Spacer()
            image?
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .padding()
            if let route = routeID {
                NavigationLink {
                    RouteView(routeID: route)
                } label: {
                    Text("Tap Me")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(8)
                }
            } else {
                Text("No locations available")
                    .padding()
            }
            Spacer()
        }
        .onAppear {
            DispatchQueue.main.async {
                let db = DBManager.shared
                do {
                    let routeID = try db.fetchRouteIDbyName(name: routeName)
                    self.routeID = routeID
                    
                    let routeDetails = try db.fetchRouteDetails(routeID: routeID)
                    self.image = imageFromString(routeDetails.mapPicture)
                    
                } catch {
                    print("Database operation failed: \(error)")
                }
            }
        }
    }
}

#Preview {
    TimerView(routeName: "Taiwan")
}
