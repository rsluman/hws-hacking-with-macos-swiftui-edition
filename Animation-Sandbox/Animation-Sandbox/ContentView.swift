//
//  ContentView.swift
//  Animation-Sandbox
//
//  Created by Roelf Sluman on 17/08/2024.
//

import SwiftUI

struct ContentView: View {
  @State private var animationAmount = 1.0
  
  var body: some View {
    Text("Click Me")
      .onTapGesture {
        animationAmount += 1
      }
      .padding(50)
      .background(.red)
      .foregroundStyle(.white)
      .clipShape(.circle)
      .padding(100)
      .scaleEffect(animationAmount)
      .blur(radius: (animationAmount - 1) * 3)
      .animation(.default, value: animationAmount)
  }
}

#Preview {
  ContentView()
}
