//
//  Constants.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/4/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

/// This contains constants that are used through out the app
struct Constants {
    
    static let flickrAPIKey = "eb69f553cdd8643c5a136e712742757e"
    
    enum FlickrPhotoSize:String {
        case Small = "s"
        case Medium = "m"
        case Big = "b"
    }
    
    enum StoryBoardVCID:String {
        case PhotoViewController
    }
}
