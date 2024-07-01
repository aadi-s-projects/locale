//
//  MapSearchView.swift
//  locale
//
//  Created by Sachin Gala on 6/30/24.
//

import SwiftUI
import MapKit

struct MapSearchView: View {
        @EnvironmentObject var localSearchService:  LocalSearchService
        @State private var search: String = ""
        
        var body: some View {
            NavigationStack {
                VStack {
                    TextField("Search", text: $search)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            localSearchService.search(query: search)
                        }.padding()
                    
                    
                    if !localSearchService.landmarks.isEmpty {
                        LandmarkListView()
                    }
                    
                    Map(coordinateRegion: $localSearchService.region, showsUserLocation: true, annotationItems: localSearchService.landmarks) { landmark in
                        MapAnnotation(coordinate: landmark.coordinate) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(localSearchService.landmark == landmark ? .red : .blue)
                                .scaleEffect(localSearchService.landmark == landmark ? 2: 1)
                        }
                       
                    }
                    .overlay(alignment: .bottomTrailing) {
                        NavigationLink {
                            
                            
                            PostView()
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 50, height: 50)
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(7)
                    }
                    
                    Spacer()
                }
            }
        }
}

#Preview {
    MapSearchView().environmentObject(LocalSearchService())
}
