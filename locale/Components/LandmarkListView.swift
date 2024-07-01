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
    
    var body: some View {
        VStack {
            List(localSearchService.landmarks) { landmark in
                VStack(alignment: .leading) {
                    Text(landmark.name)
                    Text(landmark.title)
                        .opacity(0.5)
                }
                .listRowBackground(localSearchService.landmark == landmark ? Color(UIColor.lightGray): Color.white)
                .onTapGesture {
                    localSearchService.landmark = landmark
                    withAnimation {
                        localSearchService.updateRegion(MKCoordinateRegion.regionFromLandmark(landmark))
                    }
                }
            }
        }
    }
}

#Preview {
    LandmarkListView().environmentObject(LocalSearchService())
}
