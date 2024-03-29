//
//  CustomMapOverlay.swift
//  TripMaker
//
//  Created by Megan Lin on 3/28/24.
//

import Foundation
import SwiftUI
import MapKit

struct MapOverlayView: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.contentMode = .scaleToFill
        mapView.delegate = context.coordinator
        
        let mapCenter = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        let mapSpan = MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360)
        let mapRegion = MKCoordinateRegion(center: mapCenter, span: mapSpan)
        mapView.region = mapRegion
        
        // Add custom tile overlay
        let overlay = CustomMapOverlay()
        overlay.canReplaceMapContent = true
        //mapView.addOverlay(overlay, level: .aboveLabels)
            
        return mapView
    }
        
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update map view if needed
    }
        
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
        
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let tileOverlay = overlay as? MKTileOverlay {
                return MKTileOverlayRenderer(tileOverlay: tileOverlay)
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}


class CustomMapOverlay: MKTileOverlay {
    override func url(forTilePath path: MKTileOverlayPath) -> URL {
        let mapsBundleURL = Bundle.main.url(forResource: "maps", withExtension: "bundle")
        let mapsBundle = Bundle(url: mapsBundleURL!)
        return (mapsBundle?.url(forResource: "world_map", withExtension: "jpg")!)!
    }
    
    override var boundingMapRect: MKMapRect {
        let worldRect = MKMapRect.world
        let rect = MKMapRect(x: 0, y: 0, width: worldRect.size.width, height: worldRect.size.height)
        return rect
    }
}
