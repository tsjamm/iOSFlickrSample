//
//  PhotoDetailViewModel.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/10/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

class PhotoDetailViewModel:PhotoDetailViewDataSource {
    
    var flickrPhoto:FlickrPhoto!
    
    init(flickrPhoto:FlickrPhoto) {
        self.flickrPhoto = flickrPhoto
    }
    
    func largeImageURL() -> NSURL? {
        return self.flickrPhoto.getLargeURL()
    }
    
    func placeHolderImage() -> UIImage? {
        return flickrPhoto.thumbnail
    }
    
}
