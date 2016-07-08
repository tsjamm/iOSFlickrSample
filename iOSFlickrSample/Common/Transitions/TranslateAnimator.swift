//
//  TranslateAnimator.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/8/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//


import UIKit

class TranslateAnimator:BaseTransitionAnimator {
    
    private var direction:Constants.TransitionDirection = Constants.TransitionDirection.LeftToRight
    
    init(isReverse:Bool=false) {
        super.init()
        self.doReverse = isReverse
        self.duration = 0.4
    }
    
    func setOriginState(direction:Constants.TransitionDirection) {
        self.direction = direction
    }
    
    override func doForwardTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let containerView = transitionContext.containerView(),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
                return
        }
        
        var initialFrame = CGRectZero
        let finalFrame = transitionContext.finalFrameForViewController(toVC)
        switch direction {
        case Constants.TransitionDirection.LeftToRight:
            initialFrame = CGRectOffset(finalFrame, -finalFrame.width, 0)
        default:
            ()
        }
        
        NSLog("Info: initialFrame = \(initialFrame) and finalFrame = \(finalFrame)")
        
        toVC.view.frame = initialFrame
        
        containerView.addSubview(fromVC.view)
        containerView.addSubview(toVC.view)
        
        let duration = transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, animations: {
            toVC.view.frame = finalFrame
        }) { (animationComplete) in
            if animationComplete {
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
        var finalFrame = CGRectZero
        switch direction {
        case Constants.TransitionDirection.LeftToRight:
            finalFrame = CGRectOffset(initialFrame, -initialFrame.width, 0)
        default:
            ()
        }
        
        NSLog("Info: initialFrame = \(initialFrame) and finalFrame = \(finalFrame)")
        
        toVC.view.frame = initialFrame
        fromVC.view.frame = initialFrame
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        
        let duration = transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, animations: {
            fromVC.view.frame = finalFrame
        }) { (animationComplete) in
            if animationComplete {
                transitionContext.completeTransition(true)
            }
        }
    }
    
}