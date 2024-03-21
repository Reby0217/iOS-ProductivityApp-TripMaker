//
//  SmallCardView.swift
//  TripMaker
//
//  Created by Megan Lin on 3/21/24.
//

import SwiftUI


struct SmallCardView: View {
    @Namespace var namespace
    
    @State var routeID: UUID
    @State var image: Image?
    @State var routeDetail: Route?
    
    var body: some View {
        GeometryReader { g in
            VStack(alignment: .leading) {
                HStack {
                    image?
                        .resizable()
                        .frame(width: 120, height: 90)
                        .cornerRadius(10)
                        .matchedGeometryEffect(id: "image", in: namespace)
                    
                    VStack(alignment: .leading) {
                        blurTags(tags: ["SwiftUI"], namespace: namespace)
                        Spacer()
                        Text(routeDetail?.name ?? "")
                            .foregroundColor(Color.textColor)
                            .matchedGeometryEffect(id: "title", in: namespace)
                        Spacer()
                        HStack {
                            Stars(star: 5)
                                .matchedGeometryEffect(id: "stars", in: namespace)
                            Text("(100)")
                                .font(.caption2)
                                .foregroundColor(.subtextColor)
                                .matchedGeometryEffect(id: "ratingNum", in: namespace)
                        }
                    }.padding(.leading)
                    Spacer()
                    VStack {
                        Image(systemName: "ellipsis")
                            .foregroundColor(Color.white)
                            .matchedGeometryEffect(id: "ellipsis", in: namespace)
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    SmallCardView(routeID: UUID())
}
