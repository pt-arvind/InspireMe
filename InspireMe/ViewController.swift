//
//  ViewController.swift
//  InspireMe
//
//  Created by Arvind Subramanian on 11/17/15.
//  Copyright © 2015 WeddingWire. All rights reserved.
//

import UIKit

final class QuoteDislpayObject {
    let authorText: String
    let quoteText: String
    
    init(quote: Quote) {
        quoteText = quote.text
        authorText = QuoteDislpayObject.formatAuthorText(quote.author)
    }
    
    static func formatAuthorText(authorText: String) -> String {
        return "-- \(authorText)"
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        populateQuote()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func nextQuote(sender: AnyObject) {
        populateQuote()
    }
    
    private func populateQuote() {
        let quote = QuotesManager.sharedManager.nextQuote()
        let quoteDisplay = QuoteDislpayObject(quote: quote)
        
        quoteLabel.text = quoteDisplay.quoteText
        authorLabel.text = quoteDisplay.authorText
    }
    
    

}

