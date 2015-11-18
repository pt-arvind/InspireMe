//
//  NewQuoteViewController.swift
//  InspireMe
//
//  Created by Arvind Subramanian on 11/18/15.
//  Copyright © 2015 WeddingWire. All rights reserved.
//

import UIKit

class NewQuoteViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var quoteField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var timeframeField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let done = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "dismissPicker")
        let empty = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        let toolBar = UIToolbar(frame: CGRectMake(0,0, UIScreen.mainScreen().bounds.width, 44))
        toolBar.opaque = true
        toolBar.translucent = false
        toolBar.setItems([empty, done], animated: true)
        
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        

        
        timeframeField.inputAccessoryView = toolBar
        timeframeField.inputView = pickerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    func dismissPicker() {
        timeframeField.resignFirstResponder()
    }

    @IBAction func save(sender: AnyObject) {
        guard let quoteText = quoteField.text, timeframeText = timeframeField.text, timeframe = TimeOfDay(rawValue: timeframeText) where quoteText != "" else {
            let alert = UIAlertController(title: "Hang on, Socrates!", message: "Make sure all fields are completed first!", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            }
            alert.addAction(OKAction)
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        let authorText = authorField.text
        let quote = QuoteFactory.makeQuote(quoteText, author: authorText, timeOfDay: timeframe)
        QuotesManager.sharedManager.addQuote(quote)
        
        let serializedQuotes = QuotesSerializer.serializeQuotesToDictionary(QuotesManager.sharedManager.quotes)
        let applicationDict = ["quotes" : serializedQuotes]
        PhoneToWatchConnectivitySender.sendData(applicationDict)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: UIPickerViewDelegate/UIPickerViewDataSource
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TimeOfDay.allValues().count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let timeframes = TimeOfDay.allValues()
        return timeframes[row].rawValue
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let timeframes = TimeOfDay.allValues()
        let timeframe = timeframes[row].rawValue
        timeframeField.text = timeframe
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
