//
//  Location.swift
//  MultiMap
//
//  Created by Roelf Sluman on 17/08/2024.
//

import MapKit

struct Location: Hashable, Identifiable {
  let id = UUID()
  let name: String
  let latitude: Double
  let longitude: Double
  
  var coordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
  
  // MARK: - Hashable
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
}
