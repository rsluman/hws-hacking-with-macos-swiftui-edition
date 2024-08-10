//
//  ContentView.swift
//  CowsAndBulls
//
//  Created by Roelf Sluman on 27/07/2024.
//

import SwiftUI

struct ContentView: View {
  @AppStorage("maximumGuesses") var maximumGuesses = 100
  @AppStorage("answerLength") var answerLength = 4
  @AppStorage("shouldEnableHardMode") var shouldEnableHardMode = false
  @AppStorage("shouldShowGuessCount") var shouldShowGuessCount = false

  @State private var guesses = [String]()
  @State private var guess = ""
  @State private var answer = ""
  @State private var isGameOver = false
  
  var body: some View {
    VStack(spacing: 0) {
      HStack {
        TextField("Enter a guess…", text: $guess)
          .onSubmit(submitGuess)
          
        Button("Go", action: submitGuess)
      }
      .padding()
      
      List(0..<guesses.count, id: \.self) { index in
        let guess = guesses[index]
        let shouldShowResult = shouldEnableHardMode == false || (shouldEnableHardMode && index == 0)
        
        HStack {
          Text(guess)
          Spacer()
          if shouldShowResult {
            Text(result(for: guess))
          }
        }
      }
      .listStyle(.sidebar)
      
      if shouldShowGuessCount {
        Text("Guesses: \(guesses.count) / \(maximumGuesses)")
      }
    }
    .frame(width: 250)
    .frame(minHeight: 300)
    
    .onAppear() {
      startNewGame()
    }
    
    .onChange(of: answerLength, startNewGame)
    
    .alert("You win!", isPresented: $isGameOver) {
      Button("OK", action: startNewGame)
    } message: {
      Text("Congratulations: click OK to play again.")
    }
    
    .navigationTitle("Cows and Bulls")
    
    .touchBar {
      HStack {
        Text("Guesses: \(guesses.count)")
          .touchBarItemPrincipal()
        Spacer(minLength: 200)
      }
    }
    
  }
  
  func submitGuess() {
    guard guess.count == answerLength else { return } // four numbers
    guard Set(guess).count == answerLength else { return } // four *unique* numbers
    
    let badCharacters = CharacterSet.decimalDigits.inverted
    guard guess.rangeOfCharacter(from: badCharacters) == nil else { return }
    
    guesses.insert(guess, at: 0)
    
    // Check for win
    if result(for: guess).contains("\(answerLength)b") {
      isGameOver = true
    } else {
      guess = ""
    }
    
  }
  
  func result(for guess: String) -> String {
    var bulls = 0
    var cows = 0
    
    for (position, number) in Array(guess).enumerated() {
      if number == Array(answer)[position] {
        bulls += 1
      } else if Array(answer).contains(number) {
        cows += 1
      }
    }
    
    return "\(cows)c \(bulls)b"
  }
  
  func startNewGame() {
    guard answerLength > 3 && answerLength <= 8 else { return }
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
