//
//  LocationRowView.swift
//  TripMaker
//
//  Created by Megan Lin on 3/20/24.
//

import SwiftUI

struct LocationRowView: View {
    @State var location: String
    @State var locationDetail: Location?
    
    var body: some View {
        VStack{
            imageFromString(locationDetail?.realPicture ?? "")?
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.6)
                .padding()
            Text(locationDetail?.name ?? "")
        }
            .onAppear {
                DispatchQueue.main.async {
                    let db = DBManager.shared
                    do {
                        self.locationDetail = try db.fetchLocationDetails(name: location)
                    } catch {
                        print("Location Row View Database operation failed: \(error)")
                    }
                }
            }
    }
}

#Preview {
    LocationRowView(location: "Taipei 101")
}
