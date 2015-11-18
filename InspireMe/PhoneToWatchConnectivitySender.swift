//
//  WatchConnectivitySender.swift
//  InspireMe
//
//  Created by Arvind Subramanian on 11/18/15.
//  Copyright © 2015 WeddingWire. All rights reserved.
//

import Foundation
import WatchConnectivity

final class PhoneToWatchConnectivitySender : ConnectivitySender {
    // MARK: API
    static func sendData(dataDict: [String:AnyObject]) {
        let session = WCSession.defaultSession()
        if session.watchAppInstalled {
            do {
                // behind the scenes all this can actually send is plist objects
                try session.updateApplicationContext(dataDict)
            } catch {
                // Handle errors here
                print("failed to send info to watch D:")
            }
        } else {
            print("watch app not installed yet! of course we can't send it data!")
        }
    }
}