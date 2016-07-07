//
//  PhotoViewController.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/5/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

/// The photo view controller that shows the big image for a thumbnail
class PhotoViewController:BaseViewController {

    @IBOutlet weak var imageView: UIImageView!
    var thumbnail:UIImage? = nil
    var largeImage:UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tapGesture)
        self.view.userInteractionEnabled = true
        
        if let lI = largeImage {
            self.imageView.image = lI
        } else if let thumb = thumbnail {
            self.imageView.image = thumb
        }
    }
    
    func onTap(recognizer:UITapGestureRecognizer) {
        //NSLog("Tap occurred")
        //NSLog("Info: photoFrame = \(self.imageView.frame)")
        BaseNavigationController.getInstance().popViewControllerAnimated(true)
        //self.dismissViewControllerAnimated(true, completion: nil)
    }
}