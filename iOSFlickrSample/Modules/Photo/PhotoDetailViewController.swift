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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.hidesBarsOnTap = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.hidesBarsOnTap = false
//        if let tA = self.transitionAnimator where tA.isInteractive {
//            self.navigationController?.setNavigationBarHidden(false, animated: false)
//        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
//        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }

}

extension PhotoDetailViewController: PhotoDetailViewDelegate {
    func onTap(sender:UITapGestureRecognizer) {
        if sender.numberOfTapsRequired == 2 {
            popCurrentVC(false)
        }
    }
    
    func onPan(sender:UIPanGestureRecognizer) {
        interactivePopForGestureRecognizer(sender)
    }
}