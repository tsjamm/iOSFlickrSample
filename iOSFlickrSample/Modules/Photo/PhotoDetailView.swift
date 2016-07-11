//
//  PhotoDetailView.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/10/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

protocol PhotoDetailViewDataSource: class {
    func placeHolderImage() -> UIImage?
    func largeImageURL() -> NSURL?
}

class PhotoDetailView: UIView {
    
    var dataSource: PhotoDetailViewDataSource? {
        didSet {
            guard let largeUrl = dataSource?.largeImageURL() else { return }
            imageView.af_setImageWithURL(largeUrl,
                                         placeholderImage: dataSource?.placeHolderImage(),
                                         imageTransition: .CrossDissolve(0.2),
                                         runImageTransitionIfCached: true)
        }
    }

    @IBOutlet weak var imageView: UIImageView!
    
}
