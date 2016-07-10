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

    @IBOutlet var photoDetailView: PhotoDetailView!
    
    
    @IBOutlet weak var imageView: UIImageView!
    var thumbnail:UIImage? = nil
    var largeImage:UIImage? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let lI = largeImage {
            self.imageView.image = lI
        } else if let thumb = thumbnail {
            self.imageView.image = thumb
        }
    }

}