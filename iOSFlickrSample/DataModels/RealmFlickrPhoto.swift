//
//  RealmFlickrPhoto.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/7/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit
import Realm

class RealmFlickrPhoto: RLMObject {
    
    dynamic var id:String = ""
    dynamic var title:String = ""
    dynamic var farm:Int = 0
    dynamic var owner:String = ""
    dynamic var secret:String = ""
    dynamic var server:String = ""
    dynamic var isFamily:Bool = false
    dynamic var isFriend:Bool = false
    dynamic var isPublic:Bool = false
    
}
