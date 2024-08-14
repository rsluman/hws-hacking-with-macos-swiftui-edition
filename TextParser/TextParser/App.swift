//
//  main.swift
//  TextParser
//
//  Created by Roelf Sluman on 11/08/2024.
//

import Foundation
import NaturalLanguage
import ArgumentParser

@main
struct App: ParsableCommand {
  static var configuration: CommandConfiguration {
    CommandConfiguration(commandName: "analyze", abstract: "Analyzes input text using a range of natural language approaches.")
  }
  
  @Argument(help: "The text you want to analyze")
  var input: [String]

  @Flag(name: .shortAndLong, help: "Show detected language.")
  var detectLanguage = false

  @Flag(name: .shortAndLong, help: "Prints how positive or negative the input is.")
  var sentimentAnalysis = false

  @Flag(name: .shortAndLong, help: "Shows the stem form of each word in the input.")
  var lemmatize = false

  @Flag(name: .shortAndLong, help: "Prints alternative words for each word in the input.")
  var alternatives = false

  @Flag(name: .shortAndLong, help: "Prints names of people, places, and organizations in the input.")
  var names = false
  
  @Option(name: .shortAndLong, help: "The maximum number of alternatives to suggest.")
  var maximumAlternatives = 10
  
  mutating func run() {
    let text = input.joined(separator: " ")
    
    if !detectLanguage && !sentimentAnalysis && !lemmatize && !alternatives && !names {
      detectLanguage = true
      sentimentAnalysis = true
      lemmatize = true
      alternatives = true
      names = true
    }
    
    if detectLanguage {
      let language = NLLanguageRecognizer.dominantLanguage(for: text) ?? .undetermined
      print()
      print("Detected language: \(language.rawValue)")
    }
    
    let sentiment = sentiment(for: text)
    print("Sentiment for '\(text)': \(sentiment)")
    
    lazy var lemma = lemmatize(string: text)
    
    if lemmatize {
      print()
      print("Found the following lemma:")
      print("\t", lemma.formatted(.list(type: .and)))
    }
    
    if alternatives {
      print()
      print("Found the following alternatives:")
      
      for word in lemma {
        let embeddings = embeddings(for: word)
        print("\t\(word): ", embeddings.formatted(.list(type: .and)))
      }
    }
    
    if names {
      let entities = entities(for: text)
      print()
      print("Found the following entities:")
      
      for entity in entities {
        print("\t", entity)
      }
    }
  }
 
  func sentiment(for string: String) -> Double {
    let tagger = NLTagger(tagSchemes: [.sentimentScore])
    tagger.string = string
    let (sentiment, _) = tagger.tag(at: string.startIndex, unit: .paragraph, scheme: .sentimentScore)
    guard let sentiment else { return 0 }
    
    let result = Double(sentiment.rawValue) ?? 0
    
    return result
  }
  
  func embeddings(for word: String) -> [String] {
    var results = [String]()
    
    if let embedding = NLEmbedding.wordEmbedding(for: .english) {
      let similarWords = embedding.neighbors(for: word, maximumCount: maximumAlternatives)
      for word in similarWords {
        results.append("\(word.0) has a distance of \(word.1)")
      }
    }
    
    return results
  }
  
  func lemmatize(string: String) -> [String] {
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
  
  func entities(for string: String) -> [String] {
    let tagger = NLTagger(tagSchemes: [.nameType])
    tagger.string = string
    var results = [String]()
    
    tagger.enumerateTags(in: string.startIndex..<string.endIndex, unit: .word, scheme: .nameType, options: .joinNames) { tag, range in
      guard let tag else { return true }
      
      let match = String(string[range])
      
      switch tag {
      case .organizationName:
        results.append("Organization: \(match)")
      case .personalName:
        results.append("Person: \(match)")
      case .placeName:
        results.append("Place: \(match)")
      default:
        break
      }
      return true
    }
    
    return results
  }
 
}


