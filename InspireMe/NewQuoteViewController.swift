//
//  NewQuoteViewController.swift
//  InspireMe
//
//  Created by Arvind Subramanian on 11/18/15.
//  Copyright © 2015 WeddingWire. All rights reserved.
//

import UIKit

class NewQuoteViewController: UIViewController {
    @IBOutlet weak var quoteField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func save(sender: AnyObject) {
        guard let quoteText = quoteField.text where quoteText != "" else {
            let alert = UIAlertController(title: "Hang on, Socrates!", message: "You didn't put in a quote!", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            }
            alert.addAction(OKAction)
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        let authorText = authorField.text
        let quote = QuoteFactory.makeQuote(quoteText, author: authorText)
        QuotesManager.sharedManager.addQuote(quote)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
