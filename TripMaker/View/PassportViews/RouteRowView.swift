//
//  RouteRowView.swift
//  TripMaker
//
//  Created by Megan Lin on 3/20/24.
//

import SwiftUI

struct RouteRowView: View {
    @State var route: String
    @State var routeDetail: Route?
    
    var body: some View {
        HStack {
            getStamp()?
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.4)
                .padding()
            Text(routeDetail?.name ?? "")
                .font(Font.custom("Bradley Hand", size: 22))
        }
        
        .onAppear {
            DispatchQueue.main.async {
                let db = DBManager.shared
                do {
                    self.routeDetail = try db.fetchRouteDetails(route: route)
                } catch {
                    print("Route Row View Database operation failed: \(error)")
                }
            }
        }
    }
    
    func getStamp() -> Image? {
        if routeDetail != nil {
            print("Route Row View \(routeDetail?.name)")
            return Image(uiImage:UIImage(named: (routeDetail?.name ?? "") + "-stamp.jpg")!)
        }
        return nil
    }
    
}

#Preview {
    RouteRowView(route: "Taiwan")
}
