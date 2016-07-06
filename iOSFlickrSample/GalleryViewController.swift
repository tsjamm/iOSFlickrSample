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
        
        //performSegueWithIdentifier(seguePhotoView, sender: indexPath)
        //openPhotoView(indexPath)
        
        GalleryManager.openPhotoView(indexPath, presentingVC: self, zoomOriginFrame: getRelativeCellFrameInSuperView(indexPath))
        
        return false
    }
    
    
    /// DataSource methods are in this extension, the protocol does not need to be explicitly added.
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return GalleryManager.getNumberOfSearches()
    }
    
    /// DataSource methods are in this extension, the protocol does not need to be explicitly added.
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GalleryManager.getNumberOfPhotos(section)
    }
    
    /// DataSource methods are in this extension, the protocol does not need to be explicitly added.
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FlickrPhotoCell
        cell.backgroundColor = UIColor.grayColor()
        cell.imageView.image = GalleryManager.getFlickrPhotoForIndexPath(indexPath)?.thumbnail
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
            case UICollectionElementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: self.sectionIdentifier, forIndexPath: indexPath) as! FlickrSectionHeaderView
                let fReponse = GalleryManager.getFlickrResponseForIndexPath(indexPath)
                headerView.headerLabel.text = fReponse.searchTerm
                if fReponse.isCached {
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
    
    func getRelativeCellFrameInSuperView(indexPath:NSIndexPath) -> CGRect? {
        if let cv = self.collectionView {
            if let atrb = cv.layoutAttributesForItemAtIndexPath(indexPath) {
                let cellRect = atrb.frame
                let cellFrameInSuperView = self.collectionView!.convertRect(cellRect, toView: cv.superview)
                
                return cellFrameInSuperView
                
            }
        }
        return nil
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
        guard let fPhoto = GalleryManager.getFlickrPhotoForIndexPath(indexPath) else {
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
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return self.sectionInsets
    }
    
}
