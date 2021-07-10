//
//  Skatepark.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 09.07.2021.
//

import Foundation
import SwiftUI
import CoreLocation

struct Skatepark: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    fileprivate var imageName: String
    fileprivate var coordinates: Coordinates
    var area: String
    var city: String
    var category: Category
    
    var locationCoodinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    
    var image: Image {
        ImageStore.shared.image(name: imageName)
    }
    
    enum Category: String, CaseIterable, Hashable, Codable {
        case featured = "Featured"
        case flat = "Flat"
        case ramp = "Ramp"
    }
}

struct Coordinates: Hashable, Codable {
    var latitude: Double
    var longitude: Double
}
