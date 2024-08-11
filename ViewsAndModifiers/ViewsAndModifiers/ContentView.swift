//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Roelf Sluman on 11/08/2024.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Text("Gryffindor")
        .blur(radius: 3) // adds to regular modifier
        .font(.largeTitle) // overrules environment modifier
      Text("Hufflepuff")
      Text("Ravenclaw")
      Text("Slytherin")
    }
    .blur(radius: 1) // regular modifier
    .font(.title) // environment modifier
    
  }
}

#Preview {
  ContentView()
}
