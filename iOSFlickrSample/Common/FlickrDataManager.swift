//
//  FlickrDataManager.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/4/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

/// This manages the Flickr Data Fetching Part
class FlickrDataManager {
    
    static var flickrReponseMap = [String:FlickrResponse]()
    
    static func fetchFlickerData(searchTerm:String, callback:((FlickrResponse)->())) {
        
        if let cachedResponse = getCachedFlickrResponse(searchTerm) {
            cachedResponse.isCached = true
            callback(cachedResponse)
        }
        
        FlickrNetworkManager.fetchFlickrDataFromNetwork(searchTerm) { (flickrResponse) in
            
            flickrReponseMap[searchTerm] = flickrResponse
            flickrResponse.updateInRealm()
            
            callback(flickrResponse)
            
        }
        
    }
    
    static func getCachedFlickrResponse(searchTerm:String) -> FlickrResponse? {
        if let cachedResponse = flickrReponseMap[searchTerm] {
            return cachedResponse
        } else if let realmResponse = FlickrResponse.retrieveFromRealm(searchTerm) {
            let cachedResponse = FlickrResponse(realmFlickrResponse:realmResponse)
            flickrReponseMap[searchTerm] = cachedResponse
            return cachedResponse
        }
        return nil
    }
    
    
    static func clearAllFlickrData() {
        flickrReponseMap.removeAll()
        do {
            let realm = try Realm()
            try realm.write({
                realm.deleteAll()
            })
            
        } catch {
            NSLog("Error:\n\(error)")
        }
    }
    
    
    
    
}