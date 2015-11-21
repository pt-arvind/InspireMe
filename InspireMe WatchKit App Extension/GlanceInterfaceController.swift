//
//  GlanceInterfaceController.swift
//  InspireMe
//
//  Created by Arvind Subramanian on 11/21/15.
//  Copyright © 2015 WeddingWire. All rights reserved.
//
import WatchKit
private let img_glance_queue = dispatch_queue_create("com.weddingwire.inspireme.img_glance_queue", nil)
class GlanceInterfaceController: WKInterfaceController {
    @IBOutlet var weddingLabel: WKInterfaceLabel!
    @IBOutlet var weddingCountdown: WKInterfaceTimer!
    @IBOutlet var avatarImageGroup: WKInterfaceGroup!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }


    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        dispatch_async(img_glance_queue) { () -> Void in
            let cachesDirectory = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            NSLog("trying to extract image for glance")
            if let filePath = cachesDirectory.first, fileURL = NSURL(string: "file://"+filePath)?.URLByAppendingPathComponent("userImage.png"), data = NSData(contentsOfURL: fileURL), image = UIImage(data: data) {
                NSLog("extracted image for glance")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    NSLog("setting image for glance")
                    self.avatarImageGroup.setBackgroundImage(image)
                })
            }
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
