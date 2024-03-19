//
//  LocationView.swift
//  TripMaker
//
//  Created by Megan Lin on 3/19/24.
//

import SwiftUI

struct LocationView: View {
    @Environment(ModelData.self) var modelData
    
    
    var body: some View {
        if modelData.image != ""{
            imageFromString(modelData.image)
                .scaleEffect(0.3)
        }
    }
}

#Preview {
    let modelData = ModelData()
    return LocationView()
        .environment(modelData)
}
