//
//  FlickrResponse.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/4/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import RealmSwift

class FlickrResponse {
    
    let page:Int?
    let pages:Int?
    let perPage:Int?
    let total:Int?
    
    var photo = [FlickrPhoto]()
    
    var searchTerm:String = ""
    var isCached:Bool = false
    
    var timestamp:NSTimeInterval!
    
    init(dataMap:[String:AnyObject]) {
        self.timestamp = NSDate().timeIntervalSince1970
        
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
    
    init(realmFlickrResponse:RealmFlickrResponse) {
        self.page = realmFlickrResponse.page
        self.pages = realmFlickrResponse.pages
        self.perPage = realmFlickrResponse.perPage
        self.total = realmFlickrResponse.total
        
        self.searchTerm = realmFlickrResponse.searchTerm
        self.isCached = true
        
        self.timestamp = realmFlickrResponse.timestamp
        
        for realmPhoto in realmFlickrResponse.photos {
            self.photo.append(FlickrPhoto(realmFlickrPhoto: realmPhoto))
        }
    }
    
    func toRealmFlickrResponse(realmFlickrResponse:RealmFlickrResponse=RealmFlickrResponse()) -> RealmFlickrResponse {
        //let realmFlickrResponse = RealmFlickrResponse()
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
        
        realmFlickrResponse.searchTerm = self.searchTerm
        realmFlickrResponse.timestamp = self.timestamp
        
        for flickrPhoto in self.photo {
            if let photoId = flickrPhoto.id, let retrievedRFP = FlickrPhoto.retrieveFromRealm(photoId) {
                realmFlickrResponse.photos.append(retrievedRFP)
            } else {
                realmFlickrResponse.photos.append(flickrPhoto.toRealmFlickrPhoto())
            }
        }
        return realmFlickrResponse
    }
    
    func updateInRealm() {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            if let rFR = FlickrResponse.retrieveFromRealm(self.searchTerm) {
                
                do {
                    let realm = try Realm()
                    try realm.write({
                        self.toRealmFlickrResponse(rFR)
                    })
                } catch {
                    NSLog("Error: Realm write failed for update in RealmFlickrResponse\n\(error)")
                }
                
            } else {
                
                do {
                    let realm = try Realm()
                    try realm.write({
                        realm.add(self.toRealmFlickrResponse())
                    })
                } catch {
                    NSLog("Error: Realm write failed for RealmFlickrResponse\n\(error)")
                }
                
            }
        }
    }
    
    static func retrieveFromRealm(searchTerm:String) -> RealmFlickrResponse? {
        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "searchTerm = %@", searchTerm)
            return realm.objects(RealmFlickrResponse.self).filter(predicate).first
        } catch {
            NSLog("Error: Realm read failed for RealmFlickrResponse\n\(error)")
        }
        return nil
    }
    
    static func deleteFromRealm(searchTerm:String) {
        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "searchTerm = %@", searchTerm)
            let results = realm.objects(RealmFlickrResponse.self).filter(predicate)
            for response in results {
                try realm.write({ 
                    realm.delete(response)
                })
            }
        } catch {
            NSLog("Error: Realm delete failed for RealmFlickrResponse\n\(error)")
        }
    }
    
}