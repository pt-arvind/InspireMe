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
    private static let kPlistName = "quotes"
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
    
    func updateQuotes(quotes: [Quote]) {
        self.quotes = quotes
    }
    
    func nextQuote() -> Quote  {
        return randomIndexNonEmpty(quotes)
    }
    
    private func randomIndexNonEmpty(quotes: [Quote]) -> Quote {
        let max = UInt32(quotes.count)
        if max <= 0 {
            fatalError("insufficient quotes!")
        }
        let randomIndex = Int(arc4random_uniform(max))
        return quotes[randomIndex]
    }
    
    func nextQuoteClosestToNow() -> Quote  {
        let allTimeTuples = TimeOfDay.allValues().map({ (timeOfDay) -> (NSTimeInterval?, TimeOfDay)  in
            return (timeOfDay.dateForToday()?.timeIntervalSince1970, timeOfDay)
        }).filter { (timeOfDayTuple) -> Bool in
            return timeOfDayTuple.0 != nil
        }.map { (timeOfDayTuple) -> (NSTimeInterval, TimeOfDay) in
            return (timeOfDayTuple.0!, timeOfDayTuple.1)
        }
        
        let now = NSDate().timeIntervalSince1970
        
        var minDiff: Double = abs(allTimeTuples.first!.0 - now)
        var time: TimeOfDay = .Morning
        for timeTuple in allTimeTuples {
            let diff = abs(timeTuple.0 - now)
            if diff < minDiff {
                minDiff = diff
                time = timeTuple.1
            }
        }
        
        let quotesForNow = quotes.filter { (quote) -> Bool in
            return quote.timeOfDay == time
        }
        
        return randomIndexNonEmpty(quotesForNow)
    }
    
    func addQuote(quote: Quote) {
        quotes.append(quote)
    }
}

final class QuotesSerializer {
    static func serializeQuoteToDictionary(quote: Quote) -> QuoteDict{
        var quoteDict = QuoteDict()
        quoteDict["text"] = quote.text
        quoteDict["author"] = quote.author
        quoteDict["timeframe"] = quote.timeOfDay.rawValue
        return quoteDict
    }
    
    static func serializeQuotesToDictionary(quotes: [Quote]) -> [QuoteDict] {
        var quoteDicts = [QuoteDict]()
        for quote in quotes {
            quoteDicts.append(serializeQuoteToDictionary(quote))
        }
        return quoteDicts
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
        guard let text = quoteDict["text"], timeframe = quoteDict["timeframe"], timeOfDay = TimeOfDay(rawValue: timeframe) else { return nil }
        let author = quoteDict["author"]
        
        return QuoteFactory.makeQuote(text, author: author, timeOfDay: timeOfDay)
    }
}
