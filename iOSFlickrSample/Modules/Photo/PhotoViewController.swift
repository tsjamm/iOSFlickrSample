//
//  PhotoViewController.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/5/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

/// The photo view controller that shows the big image for a thumbnail
class PhotoViewController:UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var thumbnail:UIImage? = nil
    var largeImage:UIImage? = nil
    
    let zoomAnimator = ZoomAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tapGesture)
        self.view.userInteractionEnabled = true
        
        self.transitioningDelegate = self
        
        if let lI = largeImage {
            self.imageView.image = lI
        } else if let thumb = thumbnail {
            self.imageView.image = thumb
        }
    }
    
    func onTap(recognizer:UITapGestureRecognizer) {
        NSLog("Tap occurred")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}

extension PhotoViewController:UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.zoomAnimator.doReverse = false
        return self.zoomAnimator
        //return nil
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.zoomAnimator.doReverse = true
        return self.zoomAnimator
    }
}