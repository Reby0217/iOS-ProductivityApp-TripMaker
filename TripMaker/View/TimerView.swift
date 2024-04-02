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
    
    
    var body: some View {
        VStack {
            
            RouteProgress(route: routeName, currentProgress: 0.3)
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
    TimerView(routeName: "Taiwan")
}
