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
  
  static func embeddings(for word: String) -> [String] {
    var results = [String]()
    
    if let embedding = NLEmbedding.wordEmbedding(for: .english) {
      let similarWords = embedding.neighbors(for: word, maximumCount: 10)
      for word in similarWords {
        results.append("\(word.0) has a distance of \(word.1)")
      }
    }
    
    return results
  }
  
  static func lemmatize(string: String) -> [String] {
    let tagger = NLTagger(tagSchemes: [.lemma])
    tagger.string = string
    
    var results = [String]()
    
    tagger.enumerateTags(in: string.startIndex..<string.endIndex, unit: .word, scheme: .lemma) { tag, range in
      let stemForm = tag?.rawValue ?? String(string[range]).trimmingCharacters(in: .whitespaces)
      if !stemForm.isEmpty  {
        results.append(stemForm)
      }
      return true
    }
    
    return results
  }
  
  static func main() {
    let text = CommandLine.arguments.dropFirst().joined(separator: " ")
    let sentiment = sentiment(for: text)
    print("Sentiment for '\(text)': \(sentiment)")
    print()
    print("Found the following alternatives:")
    
    let lemma = lemmatize(string: text)
    
    for word in lemma {
      let embeddings = embeddings(for: word)
      print("\t\(word): ", embeddings.formatted(.list(type: .and)))
    }
  }
}


