//
//  MapView.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 08.07.2021.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    
    var coordinates: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        return MKMapView(frame: .zero)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        
        uiView.setRegion(region, animated: true)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinates: CLLocationCoordinate2D(latitude: 55.753704, longitude: 37.625199))
    }
}
