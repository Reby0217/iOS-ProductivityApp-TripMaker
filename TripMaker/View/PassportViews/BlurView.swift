//
//  BlurView.swift
//  TripMaker
//
//  Created by Megan Lin on 3/21/24.
//


import SwiftUI


struct BlurView: UIViewRepresentable {
    
    let style: UIBlurEffect.Style
    
    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIView,
                      context: UIViewRepresentableContext<BlurView>) {
        
    }
}

enum CardPosition: CaseIterable {
    case small, big
}

struct CardDetector: View {
    
    @State var position: CardPosition
    @Namespace var namespace
    @State var route: String
    var body: some View {
        
            Group {
                switch position {
                case .small:
                    SmallCardView(namespace: namespace, route: route)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 150)
                    .background(BlurView(style: .regular))
                    .cornerRadius(10)
                    .padding(.vertical,6)
                    .onLongPressGesture {
                        withAnimation {
                            position = .big
                        }
                    }
                    .padding(.horizontal)
                case .big:
                    BigCardView(namespace: namespace, route: route)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 270)
                    .background(BlurView(style: .regular))
                    .cornerRadius(10)
                    .padding(.vertical,6)
                    .onLongPressGesture {
                        withAnimation {
                            position = .small
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
}

struct BlurryBackGroundView: View {
    @Binding var presentSideMenu: Bool
    
    @State var small = true
    @Namespace var namespace
    @State private var position: CardPosition = .small
    @State var routes: [String] = []
    @State var isPresented = false
    @State var selectedRoute = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.green.opacity(0.3), Color.yellow.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()

                ScrollView {
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
                    VStack {
                        ForEach(routes, id: \.self) { route in
                            Button(action: {
                                self.isPresented = true
                                self.selectedRoute = route
                            }) {
                                SmallCardView(namespace: namespace, route: route)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .frame(height: 150)
                                .background(BlurView(style: .regular))
                                .cornerRadius(10)
                                .padding(.vertical,6)
                                .padding(.horizontal)
                            }
                            //CardDetector(position: self.position, route: route)
                        }
                        .navigationDestination(isPresented: $isPresented) {
                            RouteView(route: selectedRoute)
                        }
                    }
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
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
    BlurryBackGroundView(presentSideMenu: .constant(true), routes : ["Taiwan", "Canada"])
}
