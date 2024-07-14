//
//  MapView.swift
//  locale
//
//  Created by Sachin Gala on 7/4/24.
//

import SwiftUI
import MapKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import PhotosUI

struct MapView: View {
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var visibleRegion: MKCoordinateRegion?
    
    @State private var selections : [String] = []
    @EnvironmentObject var postViewModel : PostViewModel
    
    @Binding var tabSelection: Int
    
    @State private var selectedPost : Post?
    
    var body: some View {
        NavigationStack {
            Map(position: $position, selection: $selectedPost) {
                UserAnnotation()
                if !selections.isEmpty {
                    ForEach(postViewModel.posts, id: \.self) { post in
                        if Set(selections.sorted()).isSubset(of: Set(post.tags)) {
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
                         DropDownView(hint: "select a vibe", options: postViewModel.universalData.validTags, selections: $selections)
                             .onChange(of: selections) { oldValue, newValue in
                                 Task {
                                     await self.postViewModel.fetchData()
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
                PostNavigationView(selectedPost: post)
                    .environmentObject(PostViewModel())
            }
        }
        .onAppear {
            Task {
                await postViewModel.fetchUniversalData()
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    MapView(tabSelection: .constant(1))
        .environmentObject(PostViewModel())
}


