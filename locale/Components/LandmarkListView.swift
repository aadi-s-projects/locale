//
//  LandmarkListView.swift
//  locale
//
//  Created by Sachin Gala on 6/30/24.
//

import SwiftUI
import MapKit

struct LandmarkListView: View {
    
    @EnvironmentObject var localSearchService: LocalSearchService
    @Environment(\.colorScheme) private var scheme

    
    var body: some View {
        VStack {
            List(localSearchService.landmarks) { landmark in
                VStack(alignment: .leading) {
                    Text(landmark.name)
                        .foregroundStyle(.white)
                        .font(Font.custom("Manrope-Light", size: 18))
                    Text(landmark.title)
                        .opacity(0.5)
                        .foregroundStyle(.white)
                        .font(Font.custom("Manrope-Light", size: 16))
                }
                .listRowBackground(localSearchService.landmark == landmark ? Color(UIColor.darkGray): Color.black)
                .onTapGesture {
                    localSearchService.landmark = landmark
                    withAnimation {
                        localSearchService.region = MKCoordinateRegion.regionFromLandmark(landmark)
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}

#Preview {
    MapSearchView(selectedLandmark: .constant(nil)).environmentObject(LocalSearchService())
}
