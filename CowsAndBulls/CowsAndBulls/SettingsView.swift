//
//  SettingsView.swift
//  CowsAndBulls
//
//  Created by Roelf Sluman on 28/07/2024.
//

import SwiftUI

struct SettingsView: View {
  @AppStorage("maximumGuesses") var maximumGuesses = 100
  @AppStorage("answerLength") var answerLength = 4
  @AppStorage("shouldEnableHardMode") var shouldEnableHardMode = false
  @AppStorage("shouldShowGuessCount") var shouldShowGuessCount = false
  
  var body: some View {
    TabView {
      Form {
        TextField("Maximum guesses", value: $maximumGuesses, format: .number)
          .help("The maximum number of answers you can submit. Changing this will immediately restart the game.")
        TextField("Answer length", value: $answerLength, format: .number)
          .help("The length of the number string to guess. Changing this will immediately restart the game.")
        
        if answerLength < 3 || answerLength > 8 {
          Text("Must be between 3 and 8")
            .foregroundStyle(.red)
        }
      }
      .tabItem {
        Label("Game", systemImage: "number.circle")
      }
      
      Form {
        Toggle("Enable hard mode", isOn: $shouldEnableHardMode)
          .help("This shows the cows and bulls score for only the most recent guess.")
        
        Toggle("Show guess count", isOn: $shouldShowGuessCount)
          .help("Adds a footer below your guesses showing the total.")
        
      }
      .tabItem {
        Label("Advanced", systemImage: "gearshape.2")
      }
    }
    .frame(width: 400)
  }
}

#Preview {
  SettingsView()
    .frame(height: 200)
}
