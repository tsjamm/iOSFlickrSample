//
//  GalleryView.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/8/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

protocol GalleryViewDelegate: class {
    func didTapOnCellAtIndexPath(collectionView:UICollectionView, indexPath:NSIndexPath)
    func scrollViewWillBeginDragging(scrollView: UIScrollView)
}

protocol GalleryViewDataSource: class {
    func getNumberOfSections() -> Int
    func getNumberOfCellsForSection(section:Int) -> Int
    func configureCellAtIndexPath(collectionView:UICollectionView, cell:GalleryPhotoCell, indexPath: NSIndexPath)
    func configureSectionHeaderAtIndexPath(collectionView:UICollectionView, sectionHeader:GallerySectionHeaderView, indexPath: NSIndexPath)
}

class GalleryView: UIView {

    var dataSource: GalleryViewDataSource? {
        didSet {
            dispatch_async(dispatch_get_main_queue(), {
                self.reloadCollectionView()
                self.removeLoadingView()
            })
        }
    }
    weak var delegate: GalleryViewDelegate?
    
    private let reuseIdentifier = "PicCell"
    private let sectionIdentifier = "SecHeader"
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    private let cellInitialSideLength:CGFloat = 100
    private let collectionViewWidthLimit1:CGFloat = 400
    private let collectionViewWidthLimit2:CGFloat = 600
    private let cellSideLengthFactor1:CGFloat = 3
    private let cellSideLengthFactor2:CGFloat = 4
    private let cellSideLengthFactor3:CGFloat = 6
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func reloadCollectionView() {
        self.collectionView.reloadData()
        //let offsetY:CGFloat = 0
        //self.collectionView.setContentOffset(CGPointMake(0, 0-offsetY), animated: true)
    }
    
    func invalidateLayout() {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
}

extension GalleryView: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        let numSections = dataSource?.getNumberOfSections()
        return numSections ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.getNumberOfCellsForSection(section) ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! GalleryPhotoCell
        dataSource?.configureCellAtIndexPath(collectionView, cell: cell, indexPath: indexPath)
        //GalleryManager.setCellInfo(cell, indexPath: indexPath, collectionView:collectionView)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: self.sectionIdentifier, forIndexPath: indexPath) as! GallerySectionHeaderView
            //GalleryManager.setSectionHeaderInfo(headerView, indexPath: indexPath)
            dataSource?.configureSectionHeaderAtIndexPath(collectionView, sectionHeader: headerView, indexPath: indexPath)
            if headerView.isLoading {
                headerView.activityIndicator.startAnimating()
            } else {
                headerView.activityIndicator.stopAnimating()
            }
            return headerView
        default: NSLog("Error: Other Supplementary View (not header, so not expected)")
        }
        return UICollectionReusableView()
    }
}

extension GalleryView: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        delegate?.didTapOnCellAtIndexPath(collectionView, indexPath: indexPath)
        return true
    }
}

extension GalleryView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let offset = (sectionInsets.left+sectionInsets.right)
        let halfOffset = offset/2
        let collectionViewWidth = collectionView.frame.width - offset
        
        var sideLength:CGFloat = cellInitialSideLength
        
        if collectionViewWidth < collectionViewWidthLimit1 {
            sideLength = collectionViewWidth/cellSideLengthFactor1 - halfOffset
        } else if collectionViewWidth < collectionViewWidthLimit2 {
            sideLength = collectionViewWidth/cellSideLengthFactor2 - halfOffset
        } else {
            sideLength = collectionViewWidth/cellSideLengthFactor3 - halfOffset
        }
        
        return CGSizeMake(sideLength, sideLength)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return self.sectionInsets
    }
    
}

extension GalleryView: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDragging(scrollView)
    }
}
