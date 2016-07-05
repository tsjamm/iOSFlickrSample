//
//  FlickrResponse.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/4/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import Foundation

class FlickrResponse {
    
    let page:Int?
    let pages:Int?
    let perPage:Int?
    let total:Int?
    
    var photo = [FlickrPhoto]()
    
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
}