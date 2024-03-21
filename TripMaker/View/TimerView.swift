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
    @State var locations: [UUID]?
    
    
    var body: some View {
        VStack {
            Spacer()
            image?
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .padding()
            if let firstLocation = locations?.first {
                NavigationLink {
                    LocationView(locationID: firstLocation)
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
                    let routeDetails = try db.fetchRouteDetails(routeID: routeID)
                    
                    self.image = imageFromString(routeDetails.mapPicture)
                    self.locations = routeDetails.locationArray.isEmpty ? nil : routeDetails.locationArray
                    
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
