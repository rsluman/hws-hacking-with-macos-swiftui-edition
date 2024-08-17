//
//  ContentView.swift
//  MultiMap
//
//  Created by Roelf Sluman on 17/08/2024.
//

import MapKit
import SwiftUI

struct ContentView: View {
  @State private var mapCamera = MapCameraPosition.region(
    MKCoordinateRegion(
      center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
      span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
    ))

  let locations =
  [Location(name: "London", latitude: 51.507222, longitude: -0.1275),
   Location(name: "Glasgow", latitude: 55.8616752, longitude: -4.2546099)
   ]

  var body: some View {
    Map(position: $mapCamera) {
      ForEach(locations) { location in
        Annotation(location.name, coordinate: location.coordinate) {
          Text(location.name)
            .font(.headline)
            .padding(5)
            .padding(.horizontal, 5)
            .background(.black)
            .foregroundStyle(.white)
            .clipShape(.capsule)
        }
      }
    }
    
  }
}

#Preview {
  ContentView()
}
