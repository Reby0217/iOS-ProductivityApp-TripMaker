//
//  PassportView.swift
//  TripMaker
//
//  Created by Megan Lin on 3/20/24.
//

import SwiftUI

struct PassportView: View {
    @Binding var presentSideMenu: Bool
    @State var routes: [UUID] = []
    
    var body: some View {
        VStack{
            HStack{
                Button{
                    presentSideMenu.toggle()
                } label: {
                    Image(systemName: "list.bullet")
                        .resizable()
                        .frame(width: 24, height: 20)
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            
            NavigationView {
                List {
                    ForEach(routes, id: \.self)
                    { route in
                        NavigationLink {
                            RouteView(routeID: route)
                        } label: {
                            RouteRowView(routeID: route)
                        }
                    }
                }
            }
        }
        
        .onAppear {
            print("passport view")
            DispatchQueue.main.async {
                let db = DBManager.shared
                do {
                    self.routes = try db.fetchAllRoutes()
                } catch {
                    print("Database operation failed: \(error)")
                }
            }
        }
    }
}

#Preview {
    PassportView(presentSideMenu: .constant(true))
}
