//
//  GalleryManager.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/6/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

class GalleryManager {
    
    private static var flickrSearchStack = [String]()
    
    static func clearSearches() {
        flickrSearchStack.removeAll()
    }
    
    static func getNumberOfSearches() -> Int {
        return self.flickrSearchStack.count
    }
    
    static func getNumberOfPhotos(forSearchIndex:Int) -> Int {
        let searchTerm = self.flickrSearchStack[forSearchIndex]
        return FlickrDataManager.getCachedFlickrResponse(searchTerm)?.photo.count ?? 0
    }
    
    static func getFlickrResponseForIndexPath(indexPath:NSIndexPath) -> FlickrResponse {
        let section = indexPath.section
        let searchTerm = self.flickrSearchStack[section]
        return FlickrDataManager.getCachedFlickrResponse(searchTerm) ?? FlickrResponse(dataMap: [:])
    }
    
    static func getFlickrPhotoForIndexPath(indexPath:NSIndexPath) -> FlickrPhoto? {
        let section = indexPath.section
        let searchTerm = self.flickrSearchStack[section]
        let row = indexPath.row
        return FlickrDataManager.getCachedFlickrResponse(searchTerm)?.photo[row]
    }
    
    static func fetchFlickrData(searchTerm:String, callback:((FlickrResponse)->())) {
        
        if let toRemoveIndex = self.flickrSearchStack.indexOf(searchTerm) {
            self.flickrSearchStack.removeAtIndex(toRemoveIndex)
        }
        
        self.flickrSearchStack.insert(searchTerm, atIndex: 0)
        FlickrDataManager.fetchFlickerData(searchTerm) { (fResponse) in
            callback(fResponse)
        }
    }
    
    static func clearFlickrData(callback:(()->())) {
        self.flickrSearchStack.removeAll()
        callback()
    }
}
