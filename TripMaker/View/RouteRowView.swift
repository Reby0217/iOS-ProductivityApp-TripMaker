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
        HStack {
            getStamp()?
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.4)
                .padding()
            Text(routeDetail?.name ?? "")
        }
        
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
    
    func getStamp() -> Image? {
        if routeDetail != nil {
            return Image(uiImage:UIImage(named: (routeDetail?.name ?? "") + "-stamp.jpg")!)
        }
        return nil
    }
    
}

#Preview {
    RouteRowView(routeID: UUID())
}
