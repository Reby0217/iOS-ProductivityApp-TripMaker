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
    
    @State var small = true
    @Namespace var namespace
    @State private var position: CardPosition = .small
    @State var routes: [String] = []
    
    var body: some View {
        HStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.green.opacity(0.3), Color.yellow.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()

                ScrollView {
                    HStack {
                        Image(systemName: "text.justify")
                            .font(.title3)
                            .foregroundColor(Color.white)
                        
                        Spacer()
                        
                        Image(systemName: "bell")
                            .font(.title2)
                            .foregroundColor(Color.white)
                    }.padding()
                    VStack {
                        ForEach(routes, id: \.self) { route in
                            CardDetector(position: self.position, route: route)
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
    BlurryBackGroundView()
}
