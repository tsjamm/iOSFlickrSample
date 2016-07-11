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
            }
        }
    }
    
    var flickrPhoto:FlickrPhoto? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}