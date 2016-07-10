//
//  PhotoDetailView.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/10/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

protocol PhotoDetailViewDataSource: class {
    func getImageForDisplay() -> UIImage?
}

class PhotoDetailView: UIView {
    
    var dataSource:PhotoDetailViewDataSource? {
        didSet {
            imageView.image = dataSource?.getImageForDisplay()
        }
    }

    @IBOutlet weak var imageView: UIImageView!
    
    
    
}
