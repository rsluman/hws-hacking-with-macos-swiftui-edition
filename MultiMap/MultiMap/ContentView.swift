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
  
  @State private var searchText = ""

  @State private var locations = [Location]()

  var body: some View {
    VStack {
      HStack {
        TextField("Search for something…", text: $searchText)
          .onSubmit(runSearch)
        
        Button("Go", action: runSearch)
      }
      .padding([.top, .horizontal])

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
  
  func runSearch() {
    Task {
      let searchRequest = MKLocalSearch.Request()
      searchRequest.naturalLanguageQuery = searchText
      
      let search = MKLocalSearch(request: searchRequest)
      let response = try await search.start()
      guard let item = response.mapItems.first else { return }
      
      guard let itemName = item.name, let itemLocation = item.placemark.location else { return }
      
      locations.append(Location(name: itemName, latitude: itemLocation.coordinate.latitude, longitude: itemLocation.coordinate.longitude))
    }
  }
}

#Preview {
  ContentView()
}
