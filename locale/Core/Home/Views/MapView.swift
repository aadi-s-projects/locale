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
    @EnvironmentObject var viewModel : PostViewModel
    
    @Binding var tabSelection: Int
    
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
                         DropDownView(hint: "Select", options: ["Chill", "Busy"], selection: $selection)
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
        }
    }
}

#Preview {
    MapView(tabSelection: .constant(1))
        .environmentObject(PostViewModel())
}
