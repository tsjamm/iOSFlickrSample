//
//  PhotoManager.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/7/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

class PhotoManager {
    
    static func showPhotoView(flickrPhoto:FlickrPhoto, presentingVC:UIViewController?=nil, zoomOriginFrame:CGRect?=nil) {
        
        if let photoVC = UIStoryboard(name: "Photo", bundle: nil).instantiateViewControllerWithIdentifier(Constants.StoryBoardVCID.PhotoViewController.rawValue) as? PhotoViewController {
            
            setInitialPhotoVCInfo(photoVC, flickrPhoto: flickrPhoto)
            
            updateLargeImageInPhoto(flickrPhoto, callback: { 
                photoVC.imageView.image = flickrPhoto.largeImage
                photoVC.view.removeLoadingView()
            })
            
            if let originFrame = zoomOriginFrame {
                photoVC.zoomAnimator.originFrame = originFrame
            }
            
            if let pVC = presentingVC {
                pVC.presentViewController(photoVC, animated: true, completion: nil)
            } else if let topVC = UIApplication.sharedApplication().keyWindow?.rootViewController {
                topVC.presentViewController(photoVC, animated: true, completion: nil)
            }
        }
        
    }
    
    static func setInitialPhotoVCInfo(photoVC:PhotoViewController, flickrPhoto:FlickrPhoto) {
        photoVC.navigationItem.title = flickrPhoto.title
        photoVC.thumbnail = flickrPhoto.thumbnail
        photoVC.largeImage = flickrPhoto.largeImage
        photoVC.view.showLoadingView()
    }
    
    static func updateLargeImageInPhoto(flickrPhoto:FlickrPhoto, callback:(()->())) {
        FlickrDataManager.downloadImageAsync(flickrPhoto, size: Constants.FlickrPhotoSize.Big.rawValue, callback: { (image) in
            flickrPhoto.largeImage = image
            callback()
        })
    }
    
}