//
//  VenueModel.swift
//  testapp
//
//  Created by Chris Ragobeer on 2016-02-18.
//  Copyright © 2016 Chris Ragobeer. All rights reserved.
//

import Foundation
import MapKit

class VenueModel: NSObject {
    
    
    var title: String?
    var coordinate: CLLocation
    var image: UIImage? = nil

    init(title: String, coordinate: CLLocation) {
        self.title = title
        self.coordinate = coordinate
        super.init()
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL) {
    
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                //print(response?.suggestedFilename ?? "")
                self.image = UIImage(data: data)!
            }
        }
    }
    
    func venueImage() -> UIImage? {
        if (image != nil) { return image!}
        else {return image}
    }
    
    


}