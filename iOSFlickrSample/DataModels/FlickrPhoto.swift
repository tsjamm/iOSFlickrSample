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
    
    static let KEY_FARM = "farm"
    static let KEY_ID = "id"
    static let KEY_IS_FAMILY = "isfamily"
    static let KEY_IS_FRIEND = "isfriend"
    static let KEY_IS_PUBLIC = "ispublic"
    static let KEY_OWNER = "owner"
    static let KEY_SECRET = "secret"
    static let KEY_SERVER = "server"
    static let KEY_TITLE = "title"
    
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
    
    /// MARK:- Initializers
    
    init(dataMap:[String:AnyObject], downloadThumb:Bool = true) {
        self.farm = dataMap[FlickrPhoto.KEY_FARM] as? Int
        self.id = dataMap[FlickrPhoto.KEY_ID] as? String
        self.isFamily = dataMap[FlickrPhoto.KEY_IS_FAMILY] as? Bool
        self.isFriend = dataMap[FlickrPhoto.KEY_IS_FRIEND] as? Bool
        self.isPublic = dataMap[FlickrPhoto.KEY_IS_PUBLIC] as? Bool
        self.owner = dataMap[FlickrPhoto.KEY_OWNER] as? String
        self.secret = dataMap[FlickrPhoto.KEY_SECRET] as? String
        self.server = dataMap[FlickrPhoto.KEY_SERVER] as? String
        self.title = dataMap[FlickrPhoto.KEY_TITLE] as? String
    }
    
    /// MARK:- Image URL getters
    
    func getThumbnailURL() -> NSURL? {
        if let toReturn = getImageURL(Constants.FlickrPhotoSize.Small.rawValue) {
            return toReturn
        }
        return nil
    }
    
    func getMediumURL() -> NSURL? {
        if let toReturn = getImageURL(Constants.FlickrPhotoSize.Medium.rawValue) {
            return toReturn
        }
        return nil
    }
    
    func getLargeURL() -> NSURL? {
        if let toReturn = getImageURL(Constants.FlickrPhotoSize.Big.rawValue) {
            return toReturn
        }
        return nil
    }
    
    private func getImageURL(size:String) -> NSURL? {
        guard let farm = self.farm else { return nil }
        guard let server = self.server else { return nil }
        guard let photoID = self.id else { return nil }
        guard let secret = self.secret else { return nil }
        
        let urlString = "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg"
        return NSURL(string: urlString)
    }
    
}