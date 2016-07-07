//
//  BaseTransitionAnimator.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/7/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import Foundation
import UIKit

class BaseTransitionAnimator:NSObject, UIViewControllerAnimatedTransitioning {
    
    var duration:NSTimeInterval = 1
    var doReverse:Bool = false
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if doReverse {
            doBackwardTransition(transitionContext)
        } else {
            doForwardTransition(transitionContext)
        }
    }
    
    func doForwardTransition(transitionContext:UIViewControllerContextTransitioning) {
        return
    }
    
    func doBackwardTransition(transitionContext:UIViewControllerContextTransitioning) {
        return
    }
}