//
//  Quote.swift
//  InspireMe
//
//  Created by Arvind Subramanian on 11/18/15.
//  Copyright © 2015 WeddingWire. All rights reserved.
//

import Foundation

final class QuoteHelper {
    static let kAnonymous = "Anonymous"
    static func validateAuthor(author: String?) -> String {
        if let author = author where author != "" {
            return author
        } else {
            return kAnonymous
        }
    }
}

final class QuoteFactory {
    static func makeQuote(text: String, author: String?) -> Quote {
        return Quote(text: text, author: QuoteHelper.validateAuthor(author))
    }
}

struct Quote : CustomDebugStringConvertible {
    let text: String
    let author: String
    
    var debugDescription: String {
        return "\(text) -- \(author)"
    }
    
    private init(text: String, author: String) {
        self.text = text
        self.author = author
    }
}






