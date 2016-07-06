//
//  GalleryManager.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/6/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

class GalleryManager {
    
    private static var flickrSearchStack = [String]()
    
    static func getNumberOfSearches() -> Int {
        return self.flickrSearchStack.count
    }
    
    static func getNumberOfPhotos(forSearchIndex:Int) -> Int {
        let searchTerm = self.flickrSearchStack[forSearchIndex]
        return FlickrDataManager.flickrReponseMap[searchTerm]?.photo.count ?? 0
    }
    
    static func getFlickrResponseForIndexPath(indexPath:NSIndexPath) -> FlickrResponse {
        let section = indexPath.section
        let searchTerm = self.flickrSearchStack[section]
        return FlickrDataManager.flickrReponseMap[searchTerm] ?? FlickrResponse(dataMap: [:])
    }
    
    static func getFlickrPhotoForIndexPath(indexPath:NSIndexPath) -> FlickrPhoto? {
        let section = indexPath.section
        let searchTerm = self.flickrSearchStack[section]
        let row = indexPath.row
        return FlickrDataManager.flickrReponseMap[searchTerm]?.photo[row]
    }
    
    static func fetchFlickrData(searchTerm:String, callback:(()->())) {
        
        if let toRemoveIndex = self.flickrSearchStack.indexOf(searchTerm) {
            self.flickrSearchStack.removeAtIndex(toRemoveIndex)
        }
        
        self.flickrSearchStack.insert(searchTerm, atIndex: 0)
        FlickrDataManager.fetchFlickerData(searchTerm) { (fResponse) in
            callback()
        }
    }
    
    static func clearFlickrData(callback:(()->())) {
        self.flickrSearchStack.removeAll()
        callback()
    }
    
    static func openPhotoView(indexPath:NSIndexPath, presentingVC:UIViewController, zoomOriginFrame:CGRect?=nil) {
        if let fPhoto = getFlickrPhotoForIndexPath(indexPath) {
            if let photoVC = UIStoryboard(name: "Photo", bundle: nil).instantiateViewControllerWithIdentifier(Constants.StoryBoardVCID.PhotoViewController.rawValue) as? PhotoViewController {
                photoVC.navigationItem.title = fPhoto.title
                //photoVC.imageView.image = fPhoto.thumbnail
                photoVC.thumbnail = fPhoto.thumbnail
                photoVC.largeImage = fPhoto.largeImage
                photoVC.view.showLoadingView()
                FlickrDataManager.downloadImageAsync(fPhoto, size: Constants.FlickrPhotoSize.Big.rawValue, callback: { (image) in
                    fPhoto.largeImage = image
                    photoVC.imageView.image = fPhoto.largeImage
                    photoVC.view.removeLoadingView()
                })
                
                if let originFrame = zoomOriginFrame {
                    photoVC.zoomAnimator.originFrame = originFrame
                }
                
                presentingVC.presentViewController(photoVC, animated: true, completion: nil)
            }
        }
    }
    
}
