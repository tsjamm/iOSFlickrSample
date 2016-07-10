//
//  GalleryViewModel.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/9/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

class GalleryViewModel: GalleryViewDataSource {
    
    private let numberOfSections = 1
    
    private var numberOfCells:Int!
    private var flickrResponse:FlickrResponse!
    
    init(flickrResponse:FlickrResponse) {
        self.flickrResponse = flickrResponse
        self.numberOfCells = flickrResponse.photo.count
    }
    
    func getNumberOfSections() -> Int {
        return self.numberOfSections
    }
    
    func getNumberOfCellsForSection(section:Int) -> Int {
        return numberOfCells
    }
    
    func configureCellAtIndexPath(collectionView:UICollectionView, cell: GalleryPhotoCell, indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.lightGrayColor()
        
        let row = indexPath.row
        
        if row < self.numberOfCells {
            let fPhoto = self.flickrResponse.photo[row]
            if let fThumb = fPhoto.thumbnail {
                cell.removeLoadingView()
                cell.imageView.image = fThumb
            } else if !self.flickrResponse.isCached { /// not downloading if cached response (not worth it)
                cell.showLoadingView()
                FlickrNetworkManager.downloadImageAsync(fPhoto, size: Constants.FlickrPhotoSize.Small.rawValue, callback: { (image) in
                    fPhoto.thumbnail = image
                    fPhoto.thumbnailTimestamp = NSDate().timeIntervalSince1970
                    if let asyncFCell = collectionView.cellForItemAtIndexPath(indexPath) as? GalleryPhotoCell {
                        //if fPhoto.thumbnailTimestamp > asyncFCell.imageTimestamp {
                        asyncFCell.imageView.image = image
                        
                        asyncFCell.removeLoadingView()
                        //}
                        asyncFCell.removeLoadingView()
                    }
                    
                })
            }
        }
    }
    
    func configureSectionHeaderAtIndexPath(collectionView:UICollectionView, sectionHeader: GallerySectionHeaderView, indexPath: NSIndexPath) {
        
        sectionHeader.headerLabel.text = self.flickrResponse.searchTerm
        sectionHeader.isLoading = self.flickrResponse.isCached
    }
    
}