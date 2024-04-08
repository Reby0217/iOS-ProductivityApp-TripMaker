//
//  SmallCardView.swift
//  TripMaker
//
//  Created by Megan Lin on 3/21/24.
//

import SwiftUI


struct SmallCardView: View {
    //@Namespace var namespace
    let namespace: Namespace.ID
    
    @State var route: String = "Taiwan"
    //@State var image: Image?
    @State var routeDetail: Route?
    
    var body: some View {
        GeometryReader { g in
            VStack(alignment: .leading) {
                HStack {
                    Image(route + "-stamp")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .cornerRadius(10)
                        //.matchedGeometryEffect(id: "image", in: namespace)
                    
                    VStack(alignment: .leading) {
                        Spacer()
                        Text(route)
                            .font(.custom("Noteworthy", size: 28))
                            .foregroundColor(Color.black)
                        //    .matchedGeometryEffect(id: "title", in: namespace)
                        Spacer()
                        //blurTags(tags: ["SwiftUI"], namespace: namespace)
                        //Spacer()
                        HStack {
                            Text("Level: ")
                                .font(.custom("Noteworthy", size: 20))
                                .foregroundColor(.black)
                            Stars(star: 5)
                        //        .matchedGeometryEffect(id: "stars", in: namespace)
                        }
                        Spacer()
                    }.padding(.leading)
                    Spacer()
                    
                }
            }
        }
    }
}

/*
 #Preview {
 SmallCardView(routeID: UUID())
 }
 */
