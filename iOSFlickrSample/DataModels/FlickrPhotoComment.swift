//
//  FlickrPhotoComment.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/20/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import Foundation

class FlickrPhotoComment {
    
    var content = ""
    var authorname = ""
    
    init(dataMap: [String:AnyObject]) {
        if let _content = dataMap["_content"] as? String {
            self.content = _content
        }
        if let _authorname = dataMap["authorname"] as? String {
            self.authorname = _authorname
        }
    }
    
}