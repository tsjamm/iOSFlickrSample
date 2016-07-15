//
//  FlickrRealmManager.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/11/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import RealmSwift

/// This class contains all the utility methods for handling realm operations.
class FlickrRealmManager {
    
    /// MARK:- Realm Methods for FlickrPhoto
    
    static func getRealmFlickrPhotoFrom(flickrPhoto: FlickrPhoto) -> RealmFlickrPhoto {
        let toReturn = RealmFlickrPhoto()
        
        if let unwrapped = flickrPhoto.farm {
            toReturn.farm = unwrapped
        }
        if let unwrapped = flickrPhoto.id {
            toReturn.id = unwrapped
        }
        if let unwrapped = flickrPhoto.isFamily {
            toReturn.isFamily = unwrapped
        }
        if let unwrapped = flickrPhoto.isFriend {
            toReturn.isFriend = unwrapped
        }
        if let unwrapped = flickrPhoto.isPublic {
            toReturn.isPublic = unwrapped
        }
        if let unwrapped = flickrPhoto.owner {
            toReturn.owner = unwrapped
        }
        if let unwrapped = flickrPhoto.secret {
            toReturn.secret = unwrapped
        }
        if let unwrapped = flickrPhoto.server {
            toReturn.server = unwrapped
        }
        if let unwrapped = flickrPhoto.title {
            toReturn.title = unwrapped
        }
        
        return toReturn
    }
    
    static func getFlickrPhotoFrom(realmFlickrPhoto: RealmFlickrPhoto) -> FlickrPhoto {
        var dataMap = [String:AnyObject]()
        
        dataMap[FlickrPhoto.KEY_FARM] = realmFlickrPhoto.farm
        dataMap[FlickrPhoto.KEY_ID] = realmFlickrPhoto.id
        dataMap[FlickrPhoto.KEY_IS_FAMILY] = realmFlickrPhoto.isFamily
        dataMap[FlickrPhoto.KEY_IS_FRIEND] = realmFlickrPhoto.isFriend
        dataMap[FlickrPhoto.KEY_IS_PUBLIC] = realmFlickrPhoto.isPublic
        dataMap[FlickrPhoto.KEY_OWNER] = realmFlickrPhoto.owner
        dataMap[FlickrPhoto.KEY_SECRET] = realmFlickrPhoto.secret
        dataMap[FlickrPhoto.KEY_SERVER] = realmFlickrPhoto.server
        dataMap[FlickrPhoto.KEY_TITLE] = realmFlickrPhoto.title
        
        return FlickrPhoto(dataMap: dataMap)
    }
    
    static func retrieveFlickrPhotoFromRealm(id: String) -> FlickrPhoto? {
        if let realmFlickrPhoto = retrieveRealmPhotoFromRealm(id) {
            return getFlickrPhotoFrom(realmFlickrPhoto)
        }
        return nil
    }
    
    private static func retrieveRealmPhotoFromRealm(id: String) -> RealmFlickrPhoto? {
        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "id = %@", id)
            return realm.objects(RealmFlickrPhoto.self).filter(predicate).first
        } catch {
            NSLog("Error: Realm read failed for RealmFlickrPhoto\n\(error)")
        }
        return nil
    }
    
    static func storeFlickrPhotoInRealm(flickrPhoto: FlickrPhoto) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            do {
                let realm = try Realm()
                try realm.write({
                    realm.add(getRealmFlickrPhotoFrom(flickrPhoto))
                })
            } catch _ {
                NSLog("Error: Realm write failed for RealmFlickrResponse")
            }
            
        }
    }
    
    /// MARK:- Realm Methods for Flickr Response
    
    static func getRealmFlickrResponseFrom(flickrResponse: FlickrResponse, realmFlickrResponse: RealmFlickrResponse = RealmFlickrResponse()) -> RealmFlickrResponse {
        if let toStore = flickrResponse.page {
            realmFlickrResponse.page = toStore
        }
        if let toStore = flickrResponse.pages {
            realmFlickrResponse.pages = toStore
        }
        if let toStore = flickrResponse.perPage {
            realmFlickrResponse.perPage = toStore
        }
        if let toStore = flickrResponse.total {
            realmFlickrResponse.total = toStore
        }
        
        realmFlickrResponse.searchTerm = flickrResponse.searchTerm
        realmFlickrResponse.timestamp = flickrResponse.timestamp
        
        for flickrPhoto in flickrResponse.photo {
            if let photoId = flickrPhoto.id, let retrievedRFP = retrieveRealmPhotoFromRealm(photoId) {
                realmFlickrResponse.photos.append(retrievedRFP)
            } else {
                realmFlickrResponse.photos.append(getRealmFlickrPhotoFrom(flickrPhoto))
            }
        }
        return realmFlickrResponse
    }
    
    static func getFlickrResponseFrom(realmFlickrResponse: RealmFlickrResponse) -> FlickrResponse {
        var dataMap = [String:AnyObject]()
        
        dataMap[FlickrResponse.KEY_PAGE] = realmFlickrResponse.page
        dataMap[FlickrResponse.KEY_PAGES] = realmFlickrResponse.pages
        dataMap[FlickrResponse.KEY_PER_PAGE] = realmFlickrResponse.perPage
        dataMap[FlickrResponse.KEY_TOTAL] = realmFlickrResponse.total
        dataMap[FlickrResponse.KEY_PHOTO] = realmFlickrResponse.photos
        
        let toReturn = FlickrResponse(dataMap: dataMap)
        toReturn.searchTerm = realmFlickrResponse.searchTerm
        toReturn.isCached = true
        toReturn.timestamp = realmFlickrResponse.timestamp
        
        for realmPhoto in realmFlickrResponse.photos {
            toReturn.photo.append(getFlickrPhotoFrom(realmPhoto))
        }
        
        return toReturn
    }
    
    static func retrieveFlickrResponseFromRealm(searchTerm: String) -> FlickrResponse? {
        if let realmResponse = retrieveRealmResponseFromRealm(searchTerm) {
            return getFlickrResponseFrom(realmResponse)
        }
        return nil
    }
    
    private static func retrieveRealmResponseFromRealm(searchTerm: String) -> RealmFlickrResponse? {
        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "searchTerm = %@", searchTerm)
            return realm.objects(RealmFlickrResponse.self).filter(predicate).first
        } catch {
            NSLog("Error: Realm read failed for RealmFlickrResponse\n\(error)")
        }
        return nil
    }
    
    static func updateFlickrResponseInRealm(searchTerm: String, newFlickrResponse: FlickrResponse) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            if let rFR = retrieveRealmResponseFromRealm(searchTerm) {
                
                do {
                    let realm = try Realm()
                    try realm.write({
                        getRealmFlickrResponseFrom(newFlickrResponse, realmFlickrResponse: rFR)
                    })
                } catch {
                    NSLog("Error: Realm write failed for update in RealmFlickrResponse\n\(error)")
                }
                
            } else {
                
                do {
                    let realm = try Realm()
                    try realm.write({
                        realm.add(getRealmFlickrResponseFrom(newFlickrResponse))
                    })
                } catch {
                    NSLog("Error: Realm write failed for RealmFlickrResponse\n\(error)")
                }
                
            }
        }
    }
    
    static func deleteFlickrResponseFromRealm(searchTerm: String) {
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