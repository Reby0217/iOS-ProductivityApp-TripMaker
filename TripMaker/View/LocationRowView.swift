//
//  LocationRowView.swift
//  TripMaker
//
//  Created by Megan Lin on 3/20/24.
//

import SwiftUI

struct LocationRowView: View {
    @State var locationID: UUID
    @State var locationDetail: Location?
    
    var body: some View {
        Text(locationDetail?.name ?? "")
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
    LocationRowView(locationID: UUID())
}
