//
//  FlickrPhoto.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/4/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit
import RealmSwift

class FlickrPhoto {
    
    let farm:Int?
    let id:String?
    let isFamily:Bool?
    let isFriend:Bool?
    let isPublic:Bool?
    let owner:String?
    let secret:String?
    let server:String?
    let title:String?
    
    var thumbnail:UIImage? = nil
    var mediumImage:UIImage? = nil
    var largeImage:UIImage? = nil
    
    var thumbnailTimestamp:NSTimeInterval!
    
    init(dataMap:[String:AnyObject], downloadThumb:Bool = true) {
        
        self.thumbnailTimestamp = NSDate().timeIntervalSince1970
        
        self.farm = dataMap["farm"] as? Int
        self.id = dataMap["id"] as? String
        self.isFamily = dataMap["isfamily"] as? Bool
        self.isFriend = dataMap["isfriend"] as? Bool
        self.isPublic = dataMap["ispublic"] as? Bool
        self.owner = dataMap["owner"] as? String
        self.secret = dataMap["secret"] as? String
        self.server = dataMap["server"] as? String
        self.title = dataMap["title"] as? String
    }
    
    init(realmFlickrPhoto:RealmFlickrPhoto) {
        self.farm = realmFlickrPhoto.farm
        self.id = realmFlickrPhoto.id
        self.isFamily = realmFlickrPhoto.isFamily
        self.isFriend = realmFlickrPhoto.isFriend
        self.isPublic = realmFlickrPhoto.isPublic
        self.owner = realmFlickrPhoto.owner
        self.secret = realmFlickrPhoto.secret
        self.server = realmFlickrPhoto.server
        self.title = realmFlickrPhoto.title
        self.thumbnailTimestamp = realmFlickrPhoto.thumbnailTimestamp
    }
    
    func toRealmFlickrPhoto() -> RealmFlickrPhoto {
        let toReturn = RealmFlickrPhoto()
        
        if let unwrapped = self.farm {
            toReturn.farm = unwrapped
        }
        if let unwrapped = self.id {
            toReturn.id = unwrapped
        }
        if let unwrapped = self.isFamily {
            toReturn.isFamily = unwrapped
        }
        if let unwrapped = self.isFriend {
            toReturn.isFriend = unwrapped
        }
        if let unwrapped = self.isPublic {
            toReturn.isPublic = unwrapped
        }
        if let unwrapped = self.owner {
            toReturn.owner = unwrapped
        }
        if let unwrapped = self.secret {
            toReturn.secret = unwrapped
        }
        if let unwrapped = self.server {
            toReturn.server = unwrapped
        }
        if let unwrapped = self.title {
            toReturn.title = unwrapped
        }
        
        toReturn.thumbnailTimestamp = self.thumbnailTimestamp
        
        return toReturn
    }
    
    func storeInRealm() {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            do {
                let realm = try Realm()
                try realm.write({
                    realm.add(self.toRealmFlickrPhoto())
                })
            } catch _ {
                NSLog("Error: Realm write failed for RealmFlickrResponse")
            }
            
        }
    }
    
    static func retrieveFromRealm(id:String) -> RealmFlickrPhoto? {
        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "id = %@", id)
            return realm.objects(RealmFlickrPhoto.self).filter(predicate).first
        } catch {
            NSLog("Error: Realm read failed for RealmFlickrPhoto\n\(error)")
        }
        return nil
    }
}