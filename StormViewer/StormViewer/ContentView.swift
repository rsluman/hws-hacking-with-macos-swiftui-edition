//
//  ContentView.swift
//  StormViewer
//
//  Created by Roelf Sluman on 27/07/2024.
//

import SwiftUI

struct ContentView: View {
  @State private var selectedImage: Int?
  
  var body: some View {
    NavigationSplitView {
      List(0..<10, selection: $selectedImage) { number in
        Text("Storm \(number + 1)")
      }
      .frame(width: 150)
    } detail: {
      if let selectedImage {
        Image("\(selectedImage)")
          .resizable()
          .scaledToFit()
      } else {
        Text("Please select an image")
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .frame(minWidth: 480, minHeight: 320)
  }
}

#Preview {
  ContentView()
}
