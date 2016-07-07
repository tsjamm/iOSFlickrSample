//
//  PhotoManager.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/7/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

class PhotoManager {
    
    static func showPhotoView(flickrPhoto:FlickrPhoto, zoomOriginFrame:CGRect?=nil) {
        
        if let photoVC = UIStoryboard(name: "Photo", bundle: nil).instantiateViewControllerWithIdentifier(Constants.StoryBoardVCID.PhotoViewController.rawValue) as? PhotoViewController {
            
            setInitialPhotoVCInfo(photoVC, flickrPhoto: flickrPhoto)
            
            updateLargeImageInPhoto(flickrPhoto, callback: { 
                //photoVC.imageView.image = flickrPhoto.largeImage
                photoVC.imageView.setImageWithAnimation(flickrPhoto.largeImage)
                photoVC.view.removeLoadingView()
                setPhotoVCAnimatorInfo(flickrPhoto, photoVC: photoVC, zoomOriginFrame: zoomOriginFrame)
            })
            
            setPhotoVCAnimatorInfo(flickrPhoto, photoVC: photoVC, zoomOriginFrame: zoomOriginFrame)
            
            
            BaseNavigationController.getInstance().pushViewController(photoVC, animated: true)
//            if let pVC = presentingVC {
//                pVC.presentViewController(photoVC, animated: true, completion: nil)
//            }
        }
        
    }
    
    static func setInitialPhotoVCInfo(photoVC:PhotoViewController, flickrPhoto:FlickrPhoto) {
        photoVC.navigationItem.title = flickrPhoto.title
        photoVC.thumbnail = flickrPhoto.thumbnail
        photoVC.largeImage = flickrPhoto.largeImage
        photoVC.view.showLoadingView()
    }
    
    static func setPhotoVCAnimatorInfo(flickrPhoto:FlickrPhoto, photoVC:PhotoViewController, zoomOriginFrame:CGRect? = nil) {
        if let originFrame = zoomOriginFrame {
            let animator = ZoomAnimator()
            var originImg:UIImage? = nil
            if let largeImg = flickrPhoto.largeImage {
                originImg = largeImg
            } else if let thumbImg = flickrPhoto.thumbnail {
                originImg = thumbImg
            }
            let originImageView = UIImageView(image: originImg)
            originImageView.contentMode = UIViewContentMode.ScaleAspectFit
            animator.setOriginState(originFrame, originView: originImageView)
            photoVC.transitionAnimator = animator
        }
    }
    
    static func updateLargeImageInPhoto(flickrPhoto:FlickrPhoto, callback:(()->())) {
        FlickrDataManager.downloadImageAsync(flickrPhoto, size: Constants.FlickrPhotoSize.Big.rawValue, callback: { (image) in
            flickrPhoto.largeImage = image
            callback()
        })
    }
    
}