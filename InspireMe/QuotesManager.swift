//
//  QuotesManager.swift
//  InspireMe
//
//  Created by Arvind Subramanian on 11/18/15.
//  Copyright © 2015 WeddingWire. All rights reserved.
//

import Foundation

typealias QuoteDict = [String : String]

final class QuotesManager {
    static let kPlistName = "quotes"
    var quotes = [Quote]()
    
    
    static let sharedManager = QuotesManager()
    private init() {
        extractQuotesFromFile(QuotesManager.kPlistName)
    }
    
    private func extractQuotesFromFile(fileName: String) {
        guard let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "plist"), let quoteDicts = NSArray(contentsOfFile: path) as? [QuoteDict] else {
            fatalError("couldn't load file: \(fileName). Path may not exist in main bundle.")
        }
        quotes = QuotesParser.quotesFromDictionaries(quoteDicts)
    }
    
    func nextQuote() -> Quote  {
        let max = UInt32(quotes.count)
        if max <= 0 {
            fatalError("insufficient quotes!")
        }
        let randomIndex = Int(arc4random_uniform(max))
        return quotes[randomIndex]
    }
}

final class QuotesParser {
    static func quotesFromDictionaries(quoteDicts: [QuoteDict]) -> [Quote] {
        var quotes = [Quote]()
        
        for quoteDict in quoteDicts {
            if let quote = quoteFromDictionary(quoteDict) {
                quotes.append(quote)
            }
        }
        
        return quotes
    }
    
    static func quoteFromDictionary(quoteDict: QuoteDict) -> Quote? {
        guard let text = quoteDict["text"] else { return nil }
        let author = quoteDict["author"]
        return QuoteFactory.makeQuote(text, author: author)
    }
}
