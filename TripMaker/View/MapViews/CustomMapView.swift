//
//  CustomMapView.swift
//  TripMaker
//
//  Created by Megan Lin on 3/28/24.
//

import SwiftUI
import MapKit


struct CustomMapView: View {
    @Binding var presentSideMenu: Bool
    
    var body: some View {
        MapOverlayView()
            .frame(width: 400, height: 400)
    }
}

#Preview {
    CustomMapView(presentSideMenu: .constant(true))
}
