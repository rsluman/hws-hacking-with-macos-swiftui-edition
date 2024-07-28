//
//  CowsAndBullsApp.swift
//  CowsAndBulls
//
//  Created by Roelf Sluman on 27/07/2024.
//

import SwiftUI

@main
struct CowsAndBullsApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .windowResizability(.contentSize)
    
    Settings {
      SettingsView.init()
    }
  }
}
