//
//  main.swift
//  TextParser
//
//  Created by Roelf Sluman on 11/08/2024.
//

import Foundation

@main
struct App {
  static func main() {
    let text = CommandLine.arguments.dropFirst().joined(separator: " ")
    print(text)
  }
}


