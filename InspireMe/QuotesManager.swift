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
    
    func extractQuotesFromFile(fileName: String) {
        guard let quoteDicts = NSArray(contentsOfFile: fileName) as? [QuoteDict] else {
            // maybe  throws?
            return
        }
        quotes = QuotesParser.quotesFromDictionaries(quoteDicts)
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
