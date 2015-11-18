//
//  WatchConnectivityManager.swift
//  InspireMe
//
//  Created by Arvind Subramanian on 11/18/15.
//  Copyright © 2015 WeddingWire. All rights reserved.
//

import Foundation
import WatchConnectivity

protocol ConnectivitySender : class {
    static func sendData(dataDict: [String : AnyObject])
}

final class WatchConnectivityManager : NSObject, WCSessionDelegate {
    static let sharedManager = WatchConnectivityManager()
    override private init() { }
    
    // MARK: WCSessionDelegate
    func setupWatchConnectivity() {
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        print("received info from watch")
        //All this is done on a BG thread
        guard let quoteDicts = applicationContext["quotes"] as? [QuoteDict] else {
            fatalError("received data of an incorrect format: \(applicationContext)")
        }
        let quotes = QuotesParser.quotesFromDictionaries(quoteDicts)
        QuotesManager.sharedManager.updateQuotes(quotes)
    }
    
    
}

