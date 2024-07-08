//
//  MapView.swift
//  locale
//
//  Created by Sachin Gala on 7/4/24.
//

import SwiftUI
import MapKit
import FirebaseFirestoreSwift
import PhotosUI

struct MapView: View {
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var visibleRegion: MKCoordinateRegion?
    
    @State private var selection : String?
    @EnvironmentObject var viewModel : PostViewModel
    
    @Binding var tabSelection: Int
    
    @State private var selectedPost : Post?
    
    @FirestoreQuery(collectionPath: "posts") var photos: [Photo]
    
    var body: some View {
        NavigationStack {
            Map(position: $position, selection: $selectedPost) {
                UserAnnotation()
                if selection != nil {
                    ForEach(viewModel.posts, id: \.self) { post in
                        if post.tag == selection {
                            Marker(post.name, systemImage: "mappin", coordinate: CLLocationCoordinate2D(latitude: post.coordinate.latitude, longitude: post.coordinate.longitude))
                                .tag(post)
                        }
                    }
                }
            }
            .mapStyle(.standard)
            .mapControls {
                MapUserLocationButton()
                    .buttonBorderShape(.circle)
                MapCompass()
                MapScaleView()
            }
            .onMapCameraChange { context in
                visibleRegion = context.region
            }
            .safeAreaInset(edge: .top) {
                HStack{
                     VStack {
                         HStack{
                             Text("find locales by vibe")
                                 .font(Font.custom("Manrope-Bold", size: CGFloat(30)))
                             
                             Spacer()
                         }
                         .padding(.top)
                         DropDownView(hint: "select a vibe", options: ["chill", "busy", "day", "night"], selection: $selection)
                             .onChange(of: selection) { oldValue, newValue in
                                 Task {
                                     await self.viewModel.fetchData()
                                 }
                             }
                             .padding(.top, -10)
                     }

                }
                .padding(.horizontal)
                .padding(.bottom)
                .background(.black)
            }
            .sheet(item: $selectedPost) { post in
                PostDetailsView(post: post, photos: photos)
                    .onAppear {
                        $photos.path = "posts/\(post.id!)/photos"
                    }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    MapView(tabSelection: .constant(1))
        .environmentObject(PostViewModel())
}


