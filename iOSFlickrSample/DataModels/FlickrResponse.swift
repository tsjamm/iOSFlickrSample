//
//  FlickrResponse.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/4/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import Realm

class FlickrResponse {
    
    let page:Int?
    let pages:Int?
    let perPage:Int?
    let total:Int?
    
    var photo = [FlickrPhoto]()
    
    var searchTerm:String = ""
    var isCached:Bool = false
    
    init(dataMap:[String:AnyObject]) {
        self.page = dataMap["page"] as? Int
        self.pages = dataMap["pages"] as? Int
        self.perPage = dataMap["perpage"] as? Int
        self.total = dataMap["total"] as? Int
        
        if let photoList = dataMap["photo"] as? [[String:AnyObject]] {
            for photoMap in photoList {
                self.photo.append(FlickrPhoto(dataMap: photoMap))
            }
        }
    }
    
    func storeInRealm() {
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        
        getRealmFlickrResponse()
        
        do {
            try realm.commitWriteTransaction()
        } catch _ {
            NSLog("Error: Realm write failed for RealmFlickrResponse")
        }
        
    }
    
    func getRealmFlickrResponse() -> RealmFlickrResponse {
        let realmFlickrResponse = RealmFlickrResponse()
        if let toStore = self.page {
            realmFlickrResponse.page = toStore
        }
        if let toStore = self.pages {
            realmFlickrResponse.pages = toStore
        }
        if let toStore = self.perPage {
            realmFlickrResponse.perPage = toStore
        }
        if let toStore = self.total {
            realmFlickrResponse.total = toStore
        }
        
        for flickrPhoto in self.photo {
            realmFlickrResponse.photos.addObject(flickrPhoto.getRealmFlickrPhoto())
        }
        return realmFlickrResponse
    }
}