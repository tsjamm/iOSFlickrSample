//
//  RealmFlickrResponse.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/7/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import RealmSwift

class RealmFlickrResponse:Object {
    
    dynamic var page:Int = 0
    dynamic var pages:Int = 0
    dynamic var perPage:Int = 0
    dynamic var total:Int = 0
    
    dynamic var searchTerm:String = ""
    dynamic var isCached:Bool = true
    
    let photos = List<RealmFlickrPhoto>()
    
}
