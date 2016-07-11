//
//  GalleryViewModel.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/9/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

struct GalleryViewModel: GalleryViewDataSource {
    
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
            /// not downloading thumb if cached response without thumb (not worth it)
            } else if !self.flickrResponse.isCached,
                let thumbURL = fPhoto.getThumbnailURL() {
                cell.showLoadingView()
                cell.imageView.af_setImageWithURL(thumbURL,
                                                  imageTransition: UIImageView.ImageTransition.CrossDissolve(0.2),
                                                  runImageTransitionIfCached: true,
                                                  completion: { (alamofireResponse) in
                    fPhoto.thumbnail = alamofireResponse.result.value
                    cell.removeLoadingView()
                })
            }
        }
    }
    
    func configureSectionHeaderAtIndexPath(collectionView:UICollectionView, sectionHeader: GallerySectionHeaderView, indexPath: NSIndexPath) {
        sectionHeader.headerLabel.text = self.flickrResponse.searchTerm
        sectionHeader.isLoading = self.flickrResponse.isCached
    }
    
}