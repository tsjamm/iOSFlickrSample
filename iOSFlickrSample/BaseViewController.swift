//
//  BaseViewController.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/7/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

class BaseViewController:UIViewController {
    
    var transitionAnimator:BaseTransitionAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.transitioningDelegate = self
    }
    
}


extension BaseViewController:UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let tA = self.transitionAnimator else {return nil}
        tA.transitionType = BaseTransitionType.presentDefault
        return tA
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let tA = self.transitionAnimator else {return nil}
        tA.transitionType = BaseTransitionType.dismissDefault
        return tA
    }
}