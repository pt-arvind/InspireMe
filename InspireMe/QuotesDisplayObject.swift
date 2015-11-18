//
//  QuotesDisplayObject.swift
//  InspireMe
//
//  Created by Arvind Subramanian on 11/18/15.
//  Copyright © 2015 WeddingWire. All rights reserved.
//

import Foundation
final class QuoteDisplayObject {
    let authorText: String
    let quoteText: String
    
    init(quote: Quote) {
        quoteText = quote.text
        authorText = QuoteDisplayObject.formatAuthorText(quote.author)
    }
    
    static func formatAuthorText(authorText: String) -> String {
        return "-- \(authorText)"
    }
}