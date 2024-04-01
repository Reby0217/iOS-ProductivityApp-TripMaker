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
    @State var isSelected = false
    
    var body: some View {
        NavigationView{
            
            VStack {
                Text(route)
                
                Spacer()
                
                Text("some description ...")
                
                Spacer()
                Spacer()
                
                Button(action: {
                    isSelected = true
                    scene.selectRoute(route: route)
                }, label: {
                    //Label("Select", systemImage: "xmark.square")
                    if isSelected {
                        Text("Select")
                            .padding(.vertical, 10)
                            .frame(width: 100)
                            .background(Color.gray.opacity(0.3))
                    } else {
                        Text("Select")
                            .padding(.vertical, 10)
                            .frame(width: 100)
                    }
                })
                .padding(.bottom, 20)
            }
            
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            scene.dismissPopover()
                            node.annotationUntapped()
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
