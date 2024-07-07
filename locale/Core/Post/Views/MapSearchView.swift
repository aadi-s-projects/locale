//
//  MapSearchView.swift
//  locale
//
//  Created by Sachin Gala on 6/30/24.
//

import SwiftUI
import MapKit

struct MapSearchView: View {
    @EnvironmentObject var localSearchService: LocalSearchService
    @State private var search: String = ""
    @Binding var selectedLandmark : Landmark?
    @EnvironmentObject var viewModel : PostViewModel

    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            CustomTextFieldView(titleKey: "search", textSize: 18, text: $search)
                .onSubmit {
                    localSearchService.search(query: search)
                }
                .padding()
            
            if !localSearchService.landmarks.isEmpty {
                LandmarkListView()
            }
            Map(coordinateRegion: $localSearchService.region, showsUserLocation: true, annotationItems: localSearchService.landmarks) { landmark in
                MapAnnotation(coordinate: landmark.coordinate) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(localSearchService.landmark == landmark ? .red : .blue)
                        .scaleEffect(localSearchService.landmark == landmark ? 2 : 1)
                }
            }
            .mapControls {
                MapUserLocationButton()
                    .buttonBorderShape(.circle)
                MapCompass()
                MapScaleView()
            }
            .overlay(alignment: .bottomTrailing) {
                Button {
                    selectedLandmark = localSearchService.landmark
                    dismiss()
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
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    MapSearchView(selectedLandmark: .constant(nil))
        .environmentObject(LocalSearchService())
        .environmentObject(PostViewModel())
}
