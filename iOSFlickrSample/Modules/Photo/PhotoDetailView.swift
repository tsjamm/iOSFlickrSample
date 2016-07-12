//
//  PhotoDetailView.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/10/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

protocol PhotoDetailViewDelegate: class {
    func onDoubleTap()
    func onPan()
}

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
    var delegate: PhotoDetailViewDelegate?

    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func onTap(sender:UITapGestureRecognizer) {
        //
        NSLog("Double Tapped on PhotoDetailView")
        delegate?.onDoubleTap()
    }
    
    @IBAction func onPan(sender:UIPanGestureRecognizer) {
        NSLog("Pan Gesture on PhotoDetailView \(sender.translationInView(self))")
        delegate?.onPan()
    }
}