//
//  ContentView.swift
//  CowsAndBulls
//
//  Created by Roelf Sluman on 27/07/2024.
//

import SwiftUI

struct ContentView: View {
  let guesses = Array(repeating: "1234", count: 20)
  
  var body: some View {
    VStack(spacing: 0) {
      HStack {
        TextField("Enter a guess…", text: .constant("1234"))
        Button("Go", action: submitGuess)
      }
      .padding()
      
      List(guesses, id: \.self) { guess in
        HStack {
          Text(guess)
          Spacer()
          Text("4c 0b")
        }
      }
    }
    .frame(width: 250)
    .frame(minHeight: 300)
  }
  
  func submitGuess() {
    
  }
  
}

#Preview {
  ContentView()
}
