//
//  PassportView.swift
//  TripMaker
//
//  Created by Megan Lin on 3/20/24.
//

import SwiftUI

struct PassportView: View {
    @Binding var presentSideMenu: Bool
    @State var routes: [String] = []
    
    var body: some View {
        VStack{
            HStack{
                Button{
                    presentSideMenu.toggle()
                } label: {
                    Image(systemName: "list.bullet")
                        .resizable()
                        .frame(width: 28, height: 24)
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            
            NavigationView {
                List {
                    ForEach(routes, id: \.self)
                    { route in
                        NavigationLink {
                            RouteView(route: route)
                        } label: {
                            RouteRowView(route: route)
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
                    print("Passport View Database operation failed: \(error)")
                }
            }
        }
    }
}

#Preview {
    PassportView(presentSideMenu: .constant(true))
}
