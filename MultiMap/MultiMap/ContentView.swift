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

  var body: some View {
    Map(position: $mapCamera)
  }
}

#Preview {
  ContentView()
}
