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
  @State private var selectedLocations = Set<Location>()
  
  var body: some View {
    NavigationSplitView {
      List(locations, id: \.self, selection: $selectedLocations) { location in
        Text(location.name)
      }
      .frame(width: 200)
    } detail: {
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
      .ignoresSafeArea()
    }
    .searchable(text: $searchText, placement: .sidebar)
    .onSubmit(of: .search, runSearch)
    
    .onChange(of: selectedLocations) {
      var visibleMap = MKMapRect.null
      for location in selectedLocations {
        let mapPoint = MKMapPoint(location.coordinate)
        let pointRect = MKMapRect(x: mapPoint.x - 100_000, y: mapPoint.y - 100_000, width: 200_000, height: 200_000)
        visibleMap = visibleMap.union(pointRect)
      }
      var newRegion = MKCoordinateRegion(visibleMap)
      newRegion.span.latitudeDelta *= 1.5
      newRegion.span.longitudeDelta *= 1.5
      mapCamera = .region(newRegion)
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
      
      let newLocation = Location(name: itemName, latitude: itemLocation.coordinate.latitude, longitude: itemLocation.coordinate.longitude)
      
      locations.append(newLocation)
      selectedLocations.insert(newLocation) // possible bug: selectedLocations = [newLocation]
    }
  }
}

#Preview {
  ContentView()
}
