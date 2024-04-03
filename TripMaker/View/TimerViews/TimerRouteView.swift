//
//  TimerRouteView.swift
//  TripMaker
//
//  Created by Megan Lin on 4/2/24.
//

import SwiftUI

struct TimerRouteView: View {
    @State var routeName: String
    @State var image: Image?
    
    
    var body: some View {
        VStack {
            
            RouteProgress(route: routeName, currentProgress: 0.7, startPos: 5)
                .frame(width: 400, height: 400)
                //.scaledToFit()
                .padding()
            
            Spacer()
        }
        .onAppear {
            DispatchQueue.main.async {
                let db = DBManager.shared
                do {
                    
                    let routeDetails = try db.fetchRouteDetails(route: routeName)
                    self.image = imageFromString(routeDetails.mapPicture)
                    
                } catch {
                    print("Timer View Database operation failed: \(error)")
                }
            }
        }
    }
}

#Preview {
    TimerRouteView(routeName: "Taiwan")
}

