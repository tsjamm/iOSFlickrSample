//
//  PhotoDetailViewController.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/5/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

/// The photo view controller that shows the big image for a thumbnail
class PhotoDetailViewController:BaseViewController {

    @IBOutlet var photoDetailView: PhotoDetailView! {
        didSet {
            if let fP = self.flickrPhoto {
                photoDetailView.dataSource = PhotoDetailViewModel(flickrPhoto: fP)
                photoDetailView.delegate = self
            }
        }
    }
    
    var flickrPhoto:FlickrPhoto? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.hidesBarsOnTap = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.navigationController?.hidesBarsOnTap = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

}

extension PhotoDetailViewController: PhotoDetailViewDelegate {
    func onDoubleTap() {
        if let nVC = self.navigationController {
            nVC.popViewControllerAnimated(true)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func onPan() {
        //TODO:-
    }
}