//
//  FlickrPhoto.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/4/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit
import Realm

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
    
    init(dataMap:[String:AnyObject], downloadThumb:Bool = true) {
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
    
    func getRealmFlickrPhoto() -> RealmFlickrPhoto {
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
        
        
        return toReturn
    }
    
    func storeInRealm() {
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        
        getRealmFlickrPhoto()
        
        do {
            try realm.commitWriteTransaction()
        } catch _ {
            NSLog("Error: Realm write failed for RealmFlickrResponse")
        }
    }
}