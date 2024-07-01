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
    @State private var searchResults: [MKMapItem] = []
    
    @State private var selection : String?
    
    var body: some View {
        NavigationStack {
            Map (position: $position) {
                UserAnnotation()
            }
            .mapStyle(.standard)
            .mapControls {
                MapUserLocationButton()
                    .buttonBorderShape(.circle)
                MapCompass()
                MapScaleView()
                
            }
            .onAppear {
                CLLocationManager().requestWhenInUseAuthorization()
            }
            .onMapCameraChange { context in
                visibleRegion = context.region
            }
            .safeAreaInset(edge: .top) {
                HStack{
                    VStack (alignment: .leading) {
                        Text("Vibe Selector")
                            .font(.title)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        DropDownView(hint: "Select", options: ["1", "2", "3"], selection: $selection)
                        
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom)
                .background(.thinMaterial)
            }
            .overlay(alignment: .bottomTrailing) {
                NavigationLink {
                    PostView()
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.white)
                    }
                }
                .padding(7)
            }
        }
    }
    
    func search(for query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = visibleRegion ?? MKCoordinateRegion(
            center: .init(latitude: 37.3346, longitude: -122.009102),
            span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125))
        
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            searchResults = response?.mapItems ?? []
        }
    }
}

#Preview {
    MapView()
}
