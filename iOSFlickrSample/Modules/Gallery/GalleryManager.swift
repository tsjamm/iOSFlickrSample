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
    
    static func showGalleryView(searchTerm:String? = nil) {
        if let galleryVC = UIStoryboard(name: "Gallery", bundle: nil).instantiateViewControllerWithIdentifier(Constants.StoryBoardVCID.GalleryViewController.rawValue) as? GalleryViewController {
            
            //BaseNavigationController.getInstance().pushViewController(galleryVC, animated: true)
            BaseNavigationController.getInstance().setViewControllers([galleryVC], animated: true)
            
            if let sTerm = searchTerm {
                galleryVC.searchField.text = sTerm
                galleryVC.doSearch()
            }
            
        }
    }
    
    
    static func getNumberOfSearches() -> Int {
        return self.flickrSearchStack.count
    }
    
    static func getNumberOfPhotos(forSearchIndex:Int) -> Int {
        let searchTerm = self.flickrSearchStack[forSearchIndex]
        return FlickrDataManager.getCachedFlickrResponse(searchTerm)?.photo.count ?? 0
    }
    
    static func getFlickrResponseForIndexPath(indexPath:NSIndexPath) -> FlickrResponse {
        let section = indexPath.section
        let searchTerm = self.flickrSearchStack[section]
        return FlickrDataManager.getCachedFlickrResponse(searchTerm) ?? FlickrResponse(dataMap: [:])
    }
    
    static func getFlickrPhotoForIndexPath(indexPath:NSIndexPath) -> FlickrPhoto? {
        let section = indexPath.section
        let searchTerm = self.flickrSearchStack[section]
        let row = indexPath.row
        return FlickrDataManager.getCachedFlickrResponse(searchTerm)?.photo[row]
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
    
    static func shouldSelectItemAtIndexPath(collectionView: UICollectionView, indexPath: NSIndexPath) -> Bool {
        if let fPhoto = getFlickrPhotoForIndexPath(indexPath) {
            
            PhotoManager.showPhotoView(fPhoto, zoomOriginFrame: collectionView.getRelativeCellFrameInSuperView(indexPath))
            
        }
        return false
    }
    
    static func sizeForItemAtIndexPath(collectionView: UICollectionView, indexPath: NSIndexPath) -> CGSize {
        guard let fPhoto = getFlickrPhotoForIndexPath(indexPath) else {
            NSLog("Error: No Photo for index path \(indexPath)")
            return CGSizeMake(100, 100)
        }
        guard let thumbnail = fPhoto.thumbnail else {
            NSLog("Error: No thumbnail for photo \(fPhoto)")
            return CGSizeMake(100,100)
        }
        var size = thumbnail.size
        size.height += 10
        size.width += 10
        return size
    }
    
    static func setCellInfo(fCell:FlickrPhotoCell, indexPath:NSIndexPath) {
        fCell.backgroundColor = UIColor.greenColor()
        fCell.imageView.image = getFlickrPhotoForIndexPath(indexPath)?.thumbnail
    }
    
    static func setSectionHeaderInfo(fSectionHeader:FlickrSectionHeaderView, indexPath:NSIndexPath) {
        let fReponse = getFlickrResponseForIndexPath(indexPath)
        fSectionHeader.headerLabel.text = fReponse.searchTerm
        fSectionHeader.isLoading = fReponse.isCached
    }
}
