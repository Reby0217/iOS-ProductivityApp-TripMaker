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
                NavigationLink {
                    LocationView(location: (locations?[0]) ?? nil)
                } label: {
                    Text("Tap Me") // Button label
                        .padding() // Add padding for better appearance
                        .background(Color.blue) // Button background color
                        .foregroundColor(Color.white) // Button text color
                        .cornerRadius(8) // Button corner radius
                }
                Spacer()
            }
        }
        .onAppear{
            let db = DBManager()
            do {
                let routeID = try db.fetchRouteIDbyName(name: routeName)
                print(routeID)
                let routeImage = try db.fetchRouteDetails(routeID: routeID).mapPicture
                self.image = imageFromString(routeImage)
                
                let location = try db.fetchLocationsForRoute(routeID: routeID)
                self.locations = location
            } catch {
                print("failed fetch route image")
            }
        }
    }
}

#Preview {
    CountryView(routeName: "Taiwan")
}
