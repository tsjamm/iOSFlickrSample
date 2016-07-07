//
//  BaseViewController.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/7/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

class BaseViewController:UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.transitioningDelegate = self
    }
    
}


extension BaseViewController:UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let tA = self.transitionAnimator else {return nil}
        tA.doReverse = false
        return tA
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let tA = self.transitionAnimator else {return nil}
        tA.doReverse = true
        return tA
    }
}