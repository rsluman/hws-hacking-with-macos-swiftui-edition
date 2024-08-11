//
//  main.swift
//  TextParser
//
//  Created by Roelf Sluman on 11/08/2024.
//

import Foundation
import NaturalLanguage

@main
struct App {
  static func sentiment(for string: String) -> Double {
    let tagger = NLTagger(tagSchemes: [.sentimentScore])
    tagger.string = string
    let (sentiment, _) = tagger.tag(at: string.startIndex, unit: .paragraph, scheme: .sentimentScore)
    guard let sentiment else { return 0 }
    
    let result = Double(sentiment.rawValue) ?? 0
    
    return result
  }
  
  static func main() {
    let text = CommandLine.arguments.dropFirst().joined(separator: " ")
    let sentiment = sentiment(for: text)
    print("Sentiment for '\(text)': \(sentiment)")
  }
}


