//
//  LocationView.swift
//  TripMaker
//
//  Created by Megan Lin on 3/19/24.
//

import SwiftUI

struct LocationView: View {
    @State var location: String
    @State var locationDetail: Location?
    
    
    var body: some View {
        VStack{
            imageFromString(locationDetail?.realPicture ?? "")?
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 400)
                .padding()
            Text(locationDetail?.name ?? "")
                .font(.title)
            Text(locationDetail?.description ?? "")
        }
        .onAppear {
            DispatchQueue.main.async {
                let db = DBManager.shared
                do {
                    self.locationDetail = try db.fetchLocationDetails(name: location)
                } catch {
                    print("Location View Database operation failed: \(error)")
                }
            }
        }
    }
}

#Preview {
    //let modelData = ModelData()
    return LocationView(location: "Taipei 101")
}
