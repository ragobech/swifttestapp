//
//  SimpleAPIManager.swift
//  testapp
//
//  Created by Chris Ragobeer on 2016-02-18.
//  Copyright © 2016 Chris Ragobeer. All rights reserved.
//
import UIKit
import Foundation
import MapKit


protocol SimpleAPIProtocol {
    func didReceiveVenues(results: [VenueModel])
}


class SimpleAPIManager: NSObject {
    
    static let sharedInstance = SimpleAPIManager()
    
    var delegate: SimpleAPIProtocol?
    
    let baseURL = "https://api.foursquare.com/v2"
    let clientIDAPIKey = "KB45V00TQB1PCVWOWRWQP3VPYAAB15BEG5VCZVGA3LADGA4B"
    let clientAPISecret = "J3R4VAADPG4N4IATDCA2NVOU1Q0FQ5LQ0ZS3TBNTFM2DVKFT"

    
    func getFourSquareVenuesRequest(location:CLLocation)  -> [VenueModel]{
        return exploreVenues(baseURL, location:location)
        
    }
    
    func exploreVenues(path: String,location: CLLocation) -> [VenueModel] {
       let requestString = "\(path)/venues/explore?client_id=\(clientIDAPIKey)&client_secret=\(clientAPISecret)&v=20130815&ll=\(location.coordinate.latitude),\(location.coordinate.longitude)"
        
        let url = NSURL(string: requestString)
        let request = NSURLRequest(URL: url!)
        let session: NSURLSession = NSURLSession.sharedSession()
        var venues = [VenueModel]()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in

            
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary {

                    if jsonResult.count>0 {
                        let response: NSDictionary = jsonResult["response"] as! NSDictionary
                        let groups:[NSDictionary] = response["groups"] as! [NSDictionary]

                        for items:NSDictionary in groups {
                            
                            let itemList: [NSDictionary] = items["items"] as! [NSDictionary]
 
                            for place:NSDictionary in itemList {
                                
                                let places : NSDictionary = place["venue"] as! NSDictionary
                                let placeName:String = places["name"] as! String
                                
                               // let photos : NSDictionary = places["photos"] as! NSDictionary
                               
                                let l: NSDictionary   = places["location"] as! NSDictionary
                                 let venueLocation:CLLocation = CLLocation(latitude: l["lat"] as! Double, longitude: l["lng"] as! Double)
                                
                                 let venueModel = VenueModel(title: placeName, coordinate: venueLocation)

                                 // couldn't get any photos ... defaulting download image..download async
                                    let fileUrl = NSURL(string: "http://orig10.deviantart.net/6eeb/f/2012/254/e/6/winnie_the_pooh_png_by_puckaabieberss-d5eeazb.png")
                                
                                    venueModel.downloadImage(fileUrl!)
                                    venues.append(venueModel)
                            }
                        }
                        self.delegate?.didReceiveVenues(venues)
                        
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        })
        
        task.resume()
        return venues
    }
    

    
    }