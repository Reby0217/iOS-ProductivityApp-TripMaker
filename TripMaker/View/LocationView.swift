//
//  LocationView.swift
//  TripMaker
//
//  Created by Megan Lin on 3/19/24.
//

import SwiftUI

struct LocationView: View {
    var location: Location?
    
    
    var body: some View {
        imageFromString(location?.realPicture ?? "")
    }
}

#Preview {
    let modelData = ModelData()
    return LocationView(location: Location(name: "Taipei 101", locationID: UUID(), realPicture: "", tagsArray: [], description: "", isLocked: false))
}
