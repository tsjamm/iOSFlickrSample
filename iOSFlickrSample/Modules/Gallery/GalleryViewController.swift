//
//  GalleryViewController.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/7/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

class GalleryViewController: BaseViewController {
    
    private let reuseIdentifier = "PicCell"
    private let sectionIdentifier = "SecHeader"
    
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.searchField.delegate = self
    }
    
    
    @IBAction func onHistoryTap(sender: AnyObject) {
        HistoryManager.showHistoryView()
    }
    
    
    @IBAction func onSearchTap(sender: AnyObject) {
        doSearch()
    }
    
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
                    var offsetY:CGFloat = 0
                    if let _ = self.navigationController {
                        offsetY += 64
                    }
                    cView.setContentOffset(CGPointMake(0, 0-offsetY), animated: true)
                }
                self.view.removeLoadingView()
            })
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let flowLayout = collectionView?.collectionViewLayout {
            flowLayout.invalidateLayout()
        }
    }
}

extension GalleryViewController:UICollectionViewDataSource {
    /// DataSource methods, the protocol does not need to be explicitly added.
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return GalleryManager.getNumberOfSearches()
    }
    
    /// DataSource methods, the protocol does not need to be explicitly added.
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GalleryManager.getNumberOfPhotos(section)
    }
    
    /// DataSource methods, the protocol does not need to be explicitly added.
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FlickrPhotoCell
        GalleryManager.setCellInfo(cell, indexPath: indexPath, collectionView:collectionView)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
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
}

extension GalleryViewController:UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return GalleryManager.shouldSelectItemAtIndexPath(collectionView, indexPath: indexPath)
        
    }
}

extension GalleryViewController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return GalleryManager.sizeForItemAtIndexPath(collectionView, indexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return self.sectionInsets
    }
    
}

extension GalleryViewController:UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        doSearch()
        return true
    }
}

extension GalleryViewController:UIScrollViewDelegate {
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.searchField.resignFirstResponder()
    }
}