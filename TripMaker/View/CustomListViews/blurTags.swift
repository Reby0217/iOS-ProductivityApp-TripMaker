//
//  blurTags.swift
//  TripMaker
//
//  Created by Megan Lin on 4/3/24.
//

import SwiftUI

struct blurTags:  View {
    
    var tags: Array<String>
    let namespace: Namespace.ID
    var body: some View {
        HStack {
            ForEach(tags, id: \.self) { tag in
                Text("\(tag)")
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .font(.caption)
                    
            }
        }.matchedGeometryEffect(id: "tags", in: namespace)
    }
}

/*
 #Preview {
 blurTags()
 }
 */
