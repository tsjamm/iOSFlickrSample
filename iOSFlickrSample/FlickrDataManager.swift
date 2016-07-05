//
//  FlickrDataManager.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/4/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireImage

/// This manages the Flickr Data Fetching Part
class FlickrDataManager {
    
    static func fetchFlickerData(searchTerm:String, callback:((FlickrResponse)->())) {
        guard let flickrURL = flickrSearchURL(searchTerm) else {
            NSLog("Error: Flickr URL not correct.")
            return
        }
        
        getJSONResult(flickrURL.absoluteString) { (response) in
            if let fResponse = processFlickrResponseObject(response.result.value) {
                fResponse.searchTerm = searchTerm
                callback(fResponse)
            }
        }
        
    }
    
    private static func getJSONResult(url:String, queryParams:[String:String]?=nil, callback:((response:Response<AnyObject, NSError>)->())) {
        Alamofire.request(.GET, url, parameters: queryParams).responseJSON(completionHandler: callback)
    }
    
    
    private static func flickrSearchURL(searchTerm:String, page:Int = 1, perPage:Int = 20) -> NSURL? {
        
        guard let escapedTerm = searchTerm.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else {
            NSLog("Error: Search Term Not Able to Escape")
            return nil
        }
        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Constants.flickrAPIKey)&text=\(escapedTerm)&per_page=\(perPage)&format=json&nojsoncallback=1&page=\(page)"
        NSLog("URLString = \(URLString)")
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
        
        downloadImages(fResponse)
        
        return fResponse
        
    }
    
    private static func downloadImages(flickrResponse:FlickrResponse) {
        for photo in flickrResponse.photo {
            photo.thumbnail = downloadImage(photo, size: Constants.FlickrPhotoSize.Small.rawValue)
            //photo.mediumImage = downloadImage(photo, size: "m")
            //photo.largeImage = downloadImage(photo, size: "b")
        }
    }
    
    static func downloadLargeImage(flickerPhoto:FlickrPhoto) {
        flickerPhoto.largeImage = downloadImage(flickerPhoto, size: Constants.FlickrPhotoSize.Big.rawValue)
    }
    
    
    private static func downloadImage(flickrPhoto:FlickrPhoto, size:String) -> UIImage? {
        if let flickrThumbURL = flickrPhoto.getImageUrl(size) {
            if let imageData = NSData(contentsOfURL: flickrThumbURL) {
                return UIImage(data: imageData)
            } else {
                NSLog("Error: Unable to fetch Flickr Image data.")
            }
        } else {
            NSLog("Error: Flickr Image URL not correct.")
        }
        return nil
    }
    
    static func downloadImageAsync(flickrPhoto:FlickrPhoto, size:String, callback:((image:UIImage)->())) {
        if let flickLargeURL = flickrPhoto.getImageUrl(Constants.FlickrPhotoSize.Big.rawValue) {
            Alamofire.request(.GET, flickLargeURL).responseImage(completionHandler: { (response) in
                if let image = response.result.value {
                    callback(image: image)
                }
            })
        }
    }
}