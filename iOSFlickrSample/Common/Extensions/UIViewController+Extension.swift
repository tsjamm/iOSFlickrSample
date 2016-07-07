//
//  UIViewController+Extension.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/7/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

var TransitionAnimatorAssociatedObjectHandle: UInt8 = 0

extension UIViewController {
    var transitionAnimator:BaseTransitionAnimator? {
        get {
            return objc_getAssociatedObject(self, &TransitionAnimatorAssociatedObjectHandle) as? BaseTransitionAnimator
        }
        set {
            objc_setAssociatedObject(self, &TransitionAnimatorAssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UIViewController:UIViewControllerTransitioningDelegate {
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let tA = self.transitionAnimator else {return nil}
        tA.doReverse = false
        return tA
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let tA = self.transitionAnimator else {return nil}
        tA.doReverse = true
        return tA
    }
}