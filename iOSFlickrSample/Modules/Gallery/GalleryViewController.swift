//
//  GalleryViewController.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/7/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

class GalleryViewController: BaseViewController {

    @IBOutlet var galleryView: GalleryView! {
        didSet {
            self.galleryView.delegate = self
        }
    }
    @IBOutlet weak var searchField: UITextField! {
        didSet {
            searchField.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func doSearchFor(text: String) {
        guard text != "" else {
            return
        }
        searchField.resignFirstResponder()
        galleryView.showLoadingView()
        GalleryManager.fetchFlickrData(text) { (fResponse) in
            self.galleryView.dataSource = GalleryViewModel(flickrResponse: fResponse)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        galleryView.invalidateLayout()
    }
    
    @IBAction func onSearchTap(sender: AnyObject) {
        if let _searchedText = searchField.text {
            doSearchFor(_searchedText)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.SegueId.GalleryToPhoto.rawValue {
            if let cell = sender as? GalleryPhotoCell {
                if let indexPath = self.galleryView.collectionView.indexPathForCell(cell) {
                    if let flickrPhoto = GalleryManager.getFlickrPhotoForIndexPath(indexPath) {
                        if let photoVC = segue.destinationViewController as? PhotoDetailViewController {
                            let zoomOriginFrame = self.galleryView.collectionView.getRelativeCellFrameInSuperView(indexPath)
                            
                            PhotoManager.setInitialPhotoVCInfo(photoVC, flickrPhoto: flickrPhoto)
                            PhotoManager.setPhotoVCAnimatorInfo(flickrPhoto, photoVC: photoVC, zoomOriginFrame: zoomOriginFrame)
                        }
                    }
                }
            }
            
        }
    }
}

extension GalleryViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let _searchedText = textField.text {
            doSearchFor(_searchedText)
        }
        return true
    }
}

extension GalleryViewController: GalleryViewDelegate {
    
    func didTapOnCellAtIndexPath(collectionView: UICollectionView, indexPath: NSIndexPath) {
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.searchField.resignFirstResponder()
    }
}
