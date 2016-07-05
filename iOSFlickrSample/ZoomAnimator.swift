//
//  ZoomAnimator.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/5/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import Foundation
import UIKit

class ZoomAnimator:NSObject, UIViewControllerAnimatedTransitioning {
    
    var originFrame:CGRect = CGRectZero
    
    var doReverse:Bool = false
    
    init(isReverse:Bool=false) {
        self.doReverse = isReverse
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let containerView = transitionContext.containerView(),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
                return
        }
        
        NSLog("Transition: \nFromVC=\(fromVC)\nToVC=\(toVC)")
        
        if doReverse {
            let initialFrame = transitionContext.finalFrameForViewController(fromVC)
            let finalFrame = originFrame
            
            let fromVCSnapshot = fromVC.view.snapshotViewAfterScreenUpdates(true)
            fromVCSnapshot.frame = initialFrame
            fromVCSnapshot.layer.cornerRadius = 25
            fromVCSnapshot.layer.masksToBounds = true
            
            containerView.addSubview(toVC.view)
            containerView.addSubview(fromVCSnapshot)
            toVC.view.hidden = false
            
            let duration = transitionDuration(transitionContext)
            
            UIView.animateWithDuration(duration, animations: {
                
                fromVCSnapshot.frame = finalFrame
                
            }) { (animationComplete) in
                if animationComplete {
                    fromVC.view.hidden = true
                    fromVCSnapshot.removeFromSuperview()
                    transitionContext.completeTransition(true)
                }
            }
        } else {
            let initialFrame = originFrame
            let finalFrame = transitionContext.finalFrameForViewController(toVC)
            
            let toVCSnapshot = toVC.view.snapshotViewAfterScreenUpdates(true)
            toVCSnapshot.frame = initialFrame
            toVCSnapshot.layer.cornerRadius = 25
            toVCSnapshot.layer.masksToBounds = true
            
            containerView.addSubview(toVC.view)
            containerView.addSubview(toVCSnapshot)
            toVC.view.hidden = true
            
            let duration = transitionDuration(transitionContext)
            
            UIView.animateWithDuration(duration, animations: {
                
                toVCSnapshot.frame = finalFrame
                
            }) { (animationComplete) in
                if animationComplete {
                    toVC.view.hidden = false
                    toVCSnapshot.removeFromSuperview()
                    transitionContext.completeTransition(true)
                }
            }
        }
    }
}