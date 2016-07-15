//
//  PhotoManager.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/7/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

class PhotoManager {
    
    static func setInitialPhotoVCInfo(photoVC:PhotoDetailViewController, flickrPhoto:FlickrPhoto) {
        photoVC.navigationItem.title = flickrPhoto.title
        photoVC.flickrPhoto = flickrPhoto
    }
    
    static func setPhotoVCAnimatorInfo(flickrPhoto:FlickrPhoto, photoVC:PhotoDetailViewController, zoomOriginFrame:CGRect? = nil) {
        if let originFrame = zoomOriginFrame {
            let animator = ZoomAnimator()
            var originImg:UIImage? = nil
//            if let largeImg = flickrPhoto.largeImage {
//                originImg = largeImg
//            } else
                if let thumbImg = flickrPhoto.thumbnail {
                originImg = thumbImg
            }
            let originImageView = UIImageView(image: originImg)
            originImageView.contentMode = UIViewContentMode.ScaleAspectFit
            animator.setOriginState(originFrame, originView: originImageView)
            photoVC.transitionAnimator = animator
        }
    }
    
}