//
//  ViewController.swift
//  InspireMe
//
//  Created by Arvind Subramanian on 11/17/15.
//  Copyright © 2015 WeddingWire. All rights reserved.
//

import UIKit
import WatchConnectivity

let imageQueue = dispatch_queue_create("com.weddingwire.inspireme.imageQueue", nil)


class QuotesViewController: UIViewController {
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var logLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateQuote()
        avatarImage.image = UIImage(named: "reagan_flags")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func log(text: String) {
        logLabel.text = text
        NSLog("\(text)")
    }
    
    @IBAction func sendImage(sender: AnyObject) {
        log("sending image")
        guard let image = UIImage(named: "reagan_flags") else { return }
        
        let imageView = UIImageView(image: image)
        log("\(imageView.frame)")
        let width = imageView.frame.width
        let height = imageView.frame.height / 5 //1/5th the frame as height
        let frame = CGRectMake(0, 0, width, height)
        let backgroundView = UIView(frame: frame)
        backgroundView.center = imageView.center
        backgroundView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.9)
        imageView.addSubview(backgroundView)
        
        //TODO: put in BGQueue
        var newImage: UIImage?
        UIGraphicsBeginImageContext(imageView.bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            log("context exists")
            imageView.layer.renderInContext(context)
            newImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        
        if let newImage = newImage {
            avatarImage.image = newImage
            log("drew image to context")
            dispatch_async(imageQueue) { () -> Void in
                
                let data = UIImagePNGRepresentation(newImage)
                
                let cachesDirectory = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
                if let data = data, filePath = cachesDirectory.first, fileURL = NSURL(string: "file://"+filePath)?.URLByAppendingPathComponent("userImage.png") {
                    // save file
                    data.writeToURL(fileURL, atomically: true)
                    self.log("wrote to file \(fileURL)")
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        // send file
                        self.log("sending file \(fileURL)")
                        let session = WCSession.defaultSession()
                        session.transferFile(fileURL, metadata: nil)
                    })
                }
            }
        }

        
    }
    
    @IBAction func nextQuote(sender: AnyObject) {
        populateQuote()
    }
    
    private func populateQuote() {
        let quote = QuotesManager.sharedManager.nextQuote()
        let quoteDisplay = QuoteDisplayObject(quote: quote)
        
        quoteLabel.text = quoteDisplay.quoteText
        authorLabel.text = quoteDisplay.authorText
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
}

