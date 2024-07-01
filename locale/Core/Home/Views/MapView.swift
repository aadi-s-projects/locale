//
//  MapView.swift
//  locale
//
//  Created by Sachin Gala on 6/29/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var visibleRegion: MKCoordinateRegion?
    
    @State private var selection : String?
    
    @EnvironmentObject var localSearchService : LocalSearchService
    @EnvironmentObject var viewModel : PostViewModel
    
    var body: some View {
        NavigationStack {
            Map (position: $position) {
                UserAnnotation()
                if selection != nil {
                    ForEach(viewModel.posts, id: \.self) { post in
                        if post.tag == selection {
                            Marker(post.name, systemImage: "mappin", coordinate: CLLocationCoordinate2D(latitude: post.coordinate.latitude, longitude: post.coordinate.longitude))
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
                             Text("Vibe Selector")
                             .font(.title)
                             .fontWeight(.bold)
                             
                             Spacer()
                         }
                         DropDownView(hint: "Select", options: ["Chill", "2", "3"], selection: $selection)
                             .onChange(of: selection) { oldValue, newValue in
                                 Task {
                                     await self.viewModel.fetchData()
                                 }
                             }
                     }

                }
                .padding(.horizontal)
                .padding(.bottom)
                .background(.thinMaterial)
            }
            .overlay(alignment: .bottomTrailing) {
                NavigationLink {
                    PostView()
                        .environmentObject(LocalSearchService())
                        .environmentObject(PostViewModel())
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    }
                }
                .padding(7)
            }
        }
    }
}

#Preview {
    MapView()
        .environmentObject(LocalSearchService())
        .environmentObject(PostViewModel())
}
