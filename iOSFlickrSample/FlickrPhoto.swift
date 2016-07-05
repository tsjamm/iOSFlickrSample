//
//  FlickrPhoto.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/4/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

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
    
    func getImageUrl(size:String=Constants.FlickrPhotoSize.Small.rawValue) -> NSURL? {
        guard let farm = self.farm else { return nil }
        guard let server = self.server else { return nil }
        guard let photoID = self.id else { return nil }
        guard let secret = self.secret else { return nil }
        
        let urlString = "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg"
        NSLog("photo url = \(urlString)")
        return NSURL(string: urlString)
    }
}