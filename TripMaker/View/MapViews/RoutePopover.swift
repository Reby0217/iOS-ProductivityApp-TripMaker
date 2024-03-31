//
//  RoutePopover.swift
//  TripMaker
//
//  Created by Megan Lin on 3/31/24.
//

import SwiftUI


struct RoutePopover: View {
    var scene: MapScene!
    var node: AnnotationNode!
    
    var route: String
    
    var body: some View {
        NavigationView{
            
            VStack {
                Text(route)
                
                Spacer()
            }
            
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            scene.dismissPopover(node: node)
                        }, label: {
                            Label("", systemImage: "xmark.square")
                        })
                    }
                }
        }
    }
}

#Preview {
    RoutePopover(route: "Taiwan")
}
