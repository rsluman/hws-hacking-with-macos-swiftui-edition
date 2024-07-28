//
//  ContentView.swift
//  CowsAndBulls
//
//  Created by Roelf Sluman on 27/07/2024.
//

import SwiftUI

struct ContentView: View {
  let answerLength = 4
  
  @State private var guesses = [String]()
  @State private var guess = ""
  @State private var answer = ""
  
  var body: some View {
    VStack(spacing: 0) {
      HStack {
        TextField("Enter a guess…", text: $guess)
          
        Button("Go", action: submitGuess)
      }
      .padding()
      
      List(guesses, id: \.self) { guess in
        HStack {
          Text(guess)
          Spacer()
          Text(result(for: guess))
        }
      }
    }
    .frame(width: 250)
    .frame(minHeight: 300)
    
    .onAppear() {
      startNewGame()
    }
  }
  
  func submitGuess() {
    if guess.count == answerLength {
      guesses.append(guess)
      guess = ""
    }
    
  }
  
  func result(for guess: String) -> String {
    return "Result"
  }
  
  func startNewGame() {
    guess = ""
    guesses.removeAll()
    createAnswer()
    
  }
  
  func createAnswer() {
    while true {
      let newAnswer = (Array(0...9).shuffled().prefix(answerLength)).reduce("") { $0 + String($1) }
      if answer != newAnswer {
        answer = newAnswer
        return
      }
    }
  }
  
}

#Preview {
  ContentView()
}
