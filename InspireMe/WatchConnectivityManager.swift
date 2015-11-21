//
//  WatchConnectivityManager.swift
//  InspireMe
//
//  Created by Arvind Subramanian on 11/18/15.
//  Copyright © 2015 WeddingWire. All rights reserved.
//

import Foundation
import WatchConnectivity
import UIKit

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
        print("received info")
        //All this is done on a BG thread
        guard let quoteDicts = applicationContext["quotes"] as? [QuoteDict] else {
            fatalError("received data of an incorrect format: \(applicationContext)")
        }
        let quotes = QuotesParser.quotesFromDictionaries(quoteDicts)
        QuotesManager.sharedManager.updateQuotes(quotes)
    }
    
    func session(session: WCSession, didFinishFileTransfer fileTransfer: WCSessionFileTransfer, error: NSError?) {
        print("file transfer completed with error: \(error)")
    }
    
    static let img_queue = dispatch_queue_create("com.weddingwire.inspireme.img_queue", nil)
    func session(session: WCSession, didReceiveFile file: WCSessionFile) {
        print("watch did receive file: \(file.fileURL)")
        
        dispatch_async(WatchConnectivityManager.img_queue) { () -> Void in
            if let data = NSData(contentsOfURL: file.fileURL), image = UIImage(data: data) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName("imageReceivedNotification", object: nil, userInfo: ["image":image])
                })
            }
        }

    }

}

