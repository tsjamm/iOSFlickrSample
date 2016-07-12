//
//  ZoomAnimator.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/5/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import Foundation
import UIKit

class ZoomAnimator: BaseTransitionAnimator {
    
    private var originFrame:CGRect = CGRectZero
    private var originView:UIView = UIView()
    
    func setOriginState(originFrame:CGRect, originView:UIView) {
        self.originFrame = originFrame
        self.originView = originView
    }
    
    override func doForwardTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let _ = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let containerView = transitionContext.containerView(),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
                return
        }
        
        let initialFrame = originFrame
        let finalFrame = transitionContext.finalFrameForViewController(toVC)
        
        let animationView = originView
        animationView.frame = initialFrame
        
        let backgroundView = UIView()
        backgroundView.frame = finalFrame
        backgroundView.backgroundColor = UIColor.whiteColor()
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(backgroundView)
        containerView.addSubview(animationView)
        
        toVC.view.hidden = true
        backgroundView.alpha = 0.0
        
        let duration = transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, animations: {
            
            animationView.frame = finalFrame
            backgroundView.alpha = 1.0
            
        }) { (animationComplete) in
            if animationComplete {
                toVC.view.hidden = false
                animationView.removeFromSuperview()
                backgroundView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }
    }
    
    override func doBackwardTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let containerView = transitionContext.containerView(),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
                return
        }
        
        let initialFrame = transitionContext.initialFrameForViewController(fromVC)
        let finalFrame = originFrame
        
        let animationView = originView
        animationView.frame = initialFrame
        
        let backgroundView = UIView()
        backgroundView.frame = initialFrame
        backgroundView.backgroundColor = UIColor.whiteColor()
        
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(backgroundView)
        containerView.addSubview(animationView)
        
        toVC.view.frame = initialFrame
        toVC.view.hidden = false
        backgroundView.alpha = 1.0
        
        let duration = transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, animations: {
            
            animationView.frame = finalFrame
            backgroundView.alpha = 0.0
            
        }) { (animationComplete) in
            if animationComplete {
                fromVC.view.hidden = true
                animationView.removeFromSuperview()
                backgroundView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }
    }
}
