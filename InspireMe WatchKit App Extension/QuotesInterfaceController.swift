//
//  InterfaceController.swift
//  InspireMe WatchKit App Extension
//
//  Created by Arvind Subramanian on 11/18/15.
//  Copyright © 2015 WeddingWire. All rights reserved.
//

import WatchKit
import Foundation


class QuotesInterfaceController: WKInterfaceController {

    @IBOutlet var quoteLabel: WKInterfaceLabel!
    @IBOutlet var authorLabel: WKInterfaceLabel!
    
    @IBOutlet var avatarGroup: WKInterfaceGroup!
    @IBAction func nextQuote() {
        populateQuote()
    }
    
    private func populateQuote() {
        let quote = QuotesManager.sharedManager.nextQuote()
        let quoteDisplay = QuoteDisplayObject(quote: quote)
        
        quoteLabel.setText(quoteDisplay.quoteText)
        authorLabel.setText(quoteDisplay.authorText)
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        populateQuote()
        NSNotificationCenter.defaultCenter().addObserverForName("imageReceivedNotification", object: nil, queue: NSOperationQueue.mainQueue()) { [weak self] (notification) -> Void in
            guard let _self = self else { return }
            print("updating UI!")
            if let userInfo = notification.userInfo, image = userInfo["image"] as? UIImage {
                print("image extracted")
                _self.avatarGroup.setBackgroundImage(image)
            }
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
