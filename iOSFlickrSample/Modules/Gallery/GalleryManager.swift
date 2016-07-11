//
//  GalleryManager.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/6/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

class GalleryManager {
    
    private static var currentSearchTerm: String = ""
    
    static func getNumberOfPhotos(forSearchIndex:Int) -> Int {
        return FlickrDataManager.getCachedFlickrResponse(currentSearchTerm)?.photo.count ?? 0
    }
    
    static func getFlickrPhotoForIndexPath(indexPath:NSIndexPath) -> FlickrPhoto? {
        let row = indexPath.row
        return FlickrDataManager.getCachedFlickrResponse(currentSearchTerm)?.photo[row]
    }
    
    static func fetchFlickrData(searchTerm:String, callback:((FlickrResponse)->())) {
        
        self.currentSearchTerm = searchTerm
        FlickrDataManager.fetchFlickerData(searchTerm) { (fResponse) in
            callback(fResponse)
        }
    }
}
