//
//  ContentView.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-16.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink {
                    CountryView(routeName: "Taiwan")
                } label: {
                    Text("Taiwan")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    
                }
            }
        } detail: {
            Text("Select an route")
        }
    }
}

#Preview {
    ContentView()
}
