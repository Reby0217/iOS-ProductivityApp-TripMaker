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
                .padding(.bottom, 20)
            HStack{
                VStack{
                    Text(locationDetail?.name ?? "Taipei 101")
                        .font(Font.custom("Noteworthy", size: 30))
                        .multilineTextAlignment(.leading)
                        
                    blurTags(tags: locationDetail?.tagsArray ?? ["test", "test"], size: 16)
                }
                Spacer()
                Image(locationDetail?.name ?? "Taipei 101")
                    .resizable()
                    .frame(width: 80, height: 80)
            }
            .padding(.horizontal, 25)
            Spacer()
            Text(locationDetail?.description ?? "")
                .font(.custom("Comic Sans MS", size: 18))
                .padding(.horizontal, 25)
            Spacer()
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
