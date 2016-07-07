//
//  GalleryViewController.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/4/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit


/// The Collection View Controller that displays the photos fetched from Flickr
class GalleryViewController: UICollectionViewController {
    
    @IBOutlet weak var searchField: UITextField!
    
    private let reuseIdentifier = "PicCell"
    private let sectionIdentifier = "SecHeader"
    //private let seguePhotoView = "showPhotoView"
    
    
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    
    func doSearch() {
        guard let searchTerm = self.searchField.text where searchTerm != ""  else {
            return
        }
        self.searchField.resignFirstResponder()
        self.view.showLoadingView()
        GalleryManager.fetchFlickrData(searchTerm) {
            dispatch_async(dispatch_get_main_queue(), { 
                if let cView = self.collectionView {
                    cView.reloadData()
                }
                self.view.removeLoadingView()
            })
        }
    }
    
    @IBAction func onSearchTap(sender: AnyObject) {
        doSearch()
    }
    @IBAction func onClearTap(sender: AnyObject) {
        GalleryManager.clearFlickrData { 
            if let cView = self.collectionView {
                cView.reloadData()
            }
            self.searchField.text = ""
        }
    }
    
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return GalleryManager.shouldSelectItemAtIndexPath(self, collectionView: collectionView, indexPath: indexPath)
        
    }
    
    
    /// DataSource methods, the protocol does not need to be explicitly added.
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return GalleryManager.getNumberOfSearches()
    }
    
    /// DataSource methods, the protocol does not need to be explicitly added.
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GalleryManager.getNumberOfPhotos(section)
    }
    
    /// DataSource methods, the protocol does not need to be explicitly added.
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FlickrPhotoCell
        GalleryManager.setCellInfo(cell, indexPath: indexPath)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
            case UICollectionElementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: self.sectionIdentifier, forIndexPath: indexPath) as! FlickrSectionHeaderView
                GalleryManager.setSectionHeaderInfo(headerView, indexPath: indexPath)
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
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.searchField.resignFirstResponder()
    }
}


/// The delegate for the search field
extension GalleryViewController:UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        doSearch()
        return true
    }
}


/// The Collection Flow Layout methods are in this extension
extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return GalleryManager.sizeForItemAtIndexPath(self, collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return self.sectionInsets
    }
    
}
