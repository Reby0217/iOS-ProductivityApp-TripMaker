//
//  CountryView.swift
//  TripMaker
//
//  Created by Megan Lin on 3/19/24.
//

import SwiftUI

struct CountryView: View {
    var routeName: String
    @State var image: Image?
    @State var locations: [Location]?
    
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                image?
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                    .padding()
                if let firstLocation = locations?.first {
                    NavigationLink {
                        LocationView(location: firstLocation)
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
        }
        .onAppear {
            DispatchQueue.main.async {
                let db = DBManager.shared
                do {
                    let routeID = try db.fetchRouteIDbyName(name: routeName)
                    let routeDetails = try db.fetchRouteDetails(routeID: routeID)
                    let locations = try db.fetchLocationsForRoute(routeID: routeID)
                    
                    self.image = imageFromString(routeDetails.mapPicture)
                    self.locations = locations.isEmpty ? nil : locations
                    
                } catch {
                    print("Database operation failed: \(error)")
                }
            }
        }



    }
}

#Preview {
    CountryView(routeName: "Taiwan")
}
