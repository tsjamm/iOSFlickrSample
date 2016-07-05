//
//  PhotosCollectionViewController.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/4/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit


/// The Collection View Controller that displays the photos fetched from Flickr
class PhotosCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var searchField: UITextField!
    
    private let reuseIdentifier = "PicCell"
    private let sectionIdentifier = "SecHeader"
    private let seguePhotoView = "showPhotoView"
    
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    private var flickrResponses = [FlickrResponse]()
    
    
    
    func photoForIndexPath(indexPath:NSIndexPath) -> FlickrPhoto? {
        let section = indexPath.section
        let row = indexPath.row
        let fResponse = flickrResponses[section]
        let fResponsePhotoList = fResponse.photo
        if fResponsePhotoList.count > row {
            return fResponse.photo[row]
        }
        return nil
    }
    
    func doSearch() {
        guard let searchTerm = self.searchField.text where searchTerm != ""  else {
            return
        }
        self.searchField.resignFirstResponder()
        self.view.showLoadingView()
        FlickrDataManager.fetchFlickerData(searchTerm) { (fResponse) in
            self.flickrResponses.insert(fResponse, atIndex: 0)
            if let cView = self.collectionView {
                cView.reloadData()
            }
            self.view.removeLoadingView()
        }
    }
    
    @IBAction func onSearchTap(sender: AnyObject) {
        doSearch()
    }
    @IBAction func onClearTap(sender: AnyObject) {
        self.flickrResponses.removeAll()
        if let cView = self.collectionView {
            cView.reloadData()
        }
        self.searchField.text = ""
    }
    
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        //TODO:- open the photo view controller
        if let flickerPhoto = photoForIndexPath(indexPath) {
            performSegueWithIdentifier(seguePhotoView, sender: flickerPhoto)
        }
        
        return false
    }
    
    
    /// DataSource methods are in this extension, the protocol does not need to be explicitly added.
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return flickrResponses.count
    }
    
    /// DataSource methods are in this extension, the protocol does not need to be explicitly added.
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrResponses[section].photo.count
    }
    
    /// DataSource methods are in this extension, the protocol does not need to be explicitly added.
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FlickrPhotoCell
        cell.backgroundColor = UIColor.grayColor()
        cell.imageView.image = photoForIndexPath(indexPath)?.thumbnail
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
            case UICollectionElementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: self.sectionIdentifier, forIndexPath: indexPath) as! FlickrSectionHeaderView
                headerView.headerLabel.text = flickrResponses[indexPath.section].searchTerm
                return headerView
            default: NSLog("Error: Other Supplementary View (not header, so not expected)")
        }
        return UICollectionReusableView()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueId = segue.identifier where segueId == seguePhotoView {
            if let fPhoto = sender as? FlickrPhoto {
            let photoVC = segue.destinationViewController as! PhotoViewController
                photoVC.navigationItem.title = fPhoto.title
                photoVC.view.showLoadingView()
                FlickrDataManager.downloadImageAsync(fPhoto, size: Constants.FlickrPhotoSize.Big.rawValue, callback: { (image) in
                    fPhoto.largeImage = image
                    photoVC.imageView.image = fPhoto.largeImage
                    photoVC.view.removeLoadingView()
                })
            }
        }
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.searchField.resignFirstResponder()
    }
}




/// The delegate for the search field
extension PhotosCollectionViewController:UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        doSearch()
        return true
    }
}


/// The Collection Flow Layout methods are in this extension
extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        guard let fPhoto = photoForIndexPath(indexPath) else {
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
