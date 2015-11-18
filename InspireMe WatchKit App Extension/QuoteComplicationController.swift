//
//  QuoteComplicationController.swift
//  InspireMe
//
//  Created by Arvind Subramanian on 11/18/15.
//  Copyright © 2015 WeddingWire. All rights reserved.
//

import Foundation
import ClockKit

class QuoteComplicationController : NSObject, CLKComplicationDataSource {
    
    /// Provide the time travel directions your complication supports (forward, backward, both, or none).
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler(.None)
    }
    /// Provide the entry that should currently be displayed.
    /// If you pass back nil, we will conclude you have no content loaded and will stop talking to you until you next call -reloadTimelineForComplication:.
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimelineEntry?) -> Void) {

        handler(nil)
    }
    
    /// When your extension is installed, this method will be called once per supported complication, and the results will be cached.
    /// If you pass back nil, we will use the default placeholder template (which is a combination of your icon and app name).
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        
        switch complication.family {
        case .ModularLarge:
            let template = CLKComplicationTemplateModularLargeStandardBody()
            
            template.headerTextProvider = CLKSimpleTextProvider(text: "Hamlet")
            template.body1TextProvider = CLKSimpleTextProvider(text: "To be or not to be, that is the question!")
            
            handler(template)
        default:
            handler(nil)
        }
    }
    
    
}