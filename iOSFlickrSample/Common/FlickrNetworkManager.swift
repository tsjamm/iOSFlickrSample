//
//  FlickrNetworkManager.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/8/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

/// This manages the network calls to Flickr
class FlickrNetworkManager {
    
    static func fetchFlickrDataFromNetwork(searchTerm:String, callback:(FlickrResponse)->()) {
        guard let flickrURL = FlickrNetworkManager.flickrSearchURL(searchTerm) else {
            NSLog("Error: Flickr URL not correct.")
            return
        }
        
        FlickrNetworkManager.getJSONResult(flickrURL.absoluteString) { (response) in
            if let fResponse = FlickrNetworkManager.processFlickrResponseObject(response.result.value) {
                fResponse.searchTerm = searchTerm
                fResponse.isCached = false
                callback(fResponse)
                
            }
        }
    }
    
    private static func getJSONResult(url:String, queryParams:[String:String]?=nil, callback:((response:Response<AnyObject, NSError>)->())) {
        Alamofire.request(.GET, url, parameters: queryParams).responseJSON(queue: dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), completionHandler: callback)
    }
    
    private static func flickrSearchURL(searchTerm:String, page:Int = 1, perPage:Int = 20) -> NSURL? {
        
        guard let escapedTerm = searchTerm.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else {
            NSLog("Error: Search Term Not Able to Escape")
            return nil
        }
        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Constants.flickrAPIKey)&text=\(escapedTerm)&per_page=\(perPage)&format=json&nojsoncallback=1&page=\(page)"
        //NSLog("URLString = \(URLString)")
        return NSURL(string: URLString)
    }
    
    private static func processFlickrResponseObject(responseObject:AnyObject?) -> FlickrResponse? {
        
        guard let responseMap = responseObject as? [String:AnyObject] else {
            NSLog("Error: Flicker Response Object is not a map...")
            return nil
        }
        guard let photosMap = responseMap["photos"] as? [String:AnyObject] else {
            NSLog("Error: Flicker Response Data does not have photos map")
            return nil
        }
        
        let fResponse = FlickrResponse(dataMap: photosMap)
        
        return fResponse
        
    }
    
}
