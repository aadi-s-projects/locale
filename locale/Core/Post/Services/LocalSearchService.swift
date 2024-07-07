//
//  LocalSearchService.swift
//  locale
//
//  Created by Sachin Gala on 6/30/24.
//

import Foundation
import MapKit
import Combine
import _MapKit_SwiftUI

class LocalSearchService: ObservableObject {
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion.defaultRegion()
    @Published var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion.defaultRegion())
    let locationManager = LocationManager()
    var regionCancellables = Set<AnyCancellable>()
    var cameraCancellables = Set<AnyCancellable>()
    @Published var landmarks: [Landmark] = []
    @Published var landmark: Landmark?
    
    init() {
        locationManager.$region.assign(to: \.region, on: self)
            .store(in: &regionCancellables)
        locationManager.$cameraPosition.assign(to: \.cameraPosition, on: self)
            .store(in: &cameraCancellables)
    }
    
    func search(query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = locationManager.region
        
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let response = response {
                let mapItems = response.mapItems
                self.landmarks = mapItems.map {
                    Landmark(placemark: $0.placemark)
                }
                self.cameraPosition = .region(self.region)
            }
        }
    }
    
    func MKMapRectForCoordinateRegion() -> MKMapRect {
        let topLeft = CLLocationCoordinate2D(latitude: region.center.latitude + (region.span.latitudeDelta/2), longitude: region.center.longitude - (region.span.longitudeDelta/2))
        let bottomRight = CLLocationCoordinate2D(latitude: region.center.latitude - (region.span.latitudeDelta/2), longitude: region.center.longitude + (region.span.longitudeDelta/2))

        let a = MKMapPoint(topLeft)
        let b = MKMapPoint(bottomRight)
        
        return MKMapRect(origin: MKMapPoint(x:min(a.x,b.x), y:min(a.y,b.y)), size: MKMapSize(width: abs(a.x-b.x), height: abs(a.y-b.y)))
    }
}
