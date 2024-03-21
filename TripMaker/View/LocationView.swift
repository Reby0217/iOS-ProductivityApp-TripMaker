//
//  LocationView.swift
//  TripMaker
//
//  Created by Megan Lin on 3/19/24.
//

import SwiftUI

struct LocationView: View {
    @State var locationID: UUID
    @State var locationDetail: Location?
    
    
    var body: some View {
        ScrollView{
            imageFromString(locationDetail?.realPicture ?? "")?
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .padding()
        }
        .onAppear {
            DispatchQueue.main.async {
                let db = DBManager.shared
                do {
                    self.locationDetail = try db.fetchLocationDetails(locationID: locationID)
                } catch {
                    print("Database operation failed: \(error)")
                }
            }
        }
    }
}

#Preview {
    let modelData = ModelData()
    return LocationView(locationID: UUID())
}
