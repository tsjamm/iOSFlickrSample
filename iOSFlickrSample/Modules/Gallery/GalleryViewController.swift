//
//  GalleryViewController.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/7/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

/// The Gallery View Controller presents a collection view of the images searched for by the search field.
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
        searchField.text = ""
        galleryView.showLoadingView()
        GalleryManager.fetchFlickrData(text) { (fResponse) in
            self.galleryView.dataSource = GalleryViewModel(flickrResponse: fResponse)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        galleryView.invalidateLayout()
        //NSLog("GalleryVC: view will layout subviews")
    }
    
    @IBAction func onSearchTap(sender: AnyObject) {
        if let _searchedText = searchField.text {
            doSearchFor(_searchedText)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.StoryBoardSegueID.GalleryToPhoto {
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
        } else if segue.identifier == Constants.StoryBoardSegueID.GalleryToHistory {
            if let historyVC = segue.destinationViewController as? HistoryViewController {
                historyVC.delegate = self
            }
        }
    }
}

/// This is for when the searchbar is handled (It is present in Navigation Item, hence not in Gallery View)
extension GalleryViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let _searchedText = textField.text {
            doSearchFor(_searchedText)
        }
        return true
    }
}

/// This is for when the user does something in the GalleryView
extension GalleryViewController: GalleryViewDelegate {
    
    func didTapOnCellAtIndexPath(collectionView: UICollectionView, indexPath: NSIndexPath) {
        // the storyboard segue is currently showing the photo view controller.
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.searchField.resignFirstResponder()
    }
}

/// This is for when user does something in the History View Controller
extension GalleryViewController: HistoryViewControllerDelegate {
    func searchHistoryCleared() {
        self.galleryView.dataSource = nil
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func didTapOnHistoricalSearch(searchTerm: String) {
        doSearchFor(searchTerm)
        self.navigationController?.popViewControllerAnimated(true)
    }
}
