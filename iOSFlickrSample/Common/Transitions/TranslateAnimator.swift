//
//  TranslateAnimator.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/8/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//


import UIKit

//MARK: TransitionDirection
enum TranslateTransitionDirection {
    case toTop
    case toRight
    case toBottom
    case toLeft
    case fromTop
    case fromRight
    case fromBottom
    case fromLeft
    
    func finalFrame(respectToInitialFrame frame: CGRect, forTransitionType type:BaseTransitionType) -> CGRect {
        switch type {
        case .presentDefault, .present(_):
            return offsetTypeOne(frame)
        case .dismissDefault, .dismiss(_):
            return offsetTypeTwo(frame)
        }
    }
    
    func initialFrame(respectToFinalFrame frame: CGRect, forTransitionType type:BaseTransitionType) -> CGRect {
        switch type {
        case .presentDefault, .present(_):
            return offsetTypeTwo(frame)
        case .dismissDefault, .dismiss(_):
            return offsetTypeOne(frame)
        }
    }
    
    private func offsetTypeOne(frame:CGRect) -> CGRect {
        switch self {
        case .toTop, .fromBottom:
            return CGRectOffset(frame, 0, -UIScreen.mainScreen().bounds.size.height)
        case .toRight, .fromLeft:
            return CGRectOffset(frame, UIScreen.mainScreen().bounds.size.width, 0)
        case .toBottom, .fromTop:
            return CGRectOffset(frame, 0, UIScreen.mainScreen().bounds.size.height)
        case .toLeft, .fromRight:
            return CGRectOffset(frame, -UIScreen.mainScreen().bounds.size.width, 0)
        }
    }
    
    private func offsetTypeTwo(frame:CGRect) -> CGRect {
        switch self {
        case .toTop, .fromBottom:
            return CGRectOffset(frame, 0, UIScreen.mainScreen().bounds.size.height)
        case .toRight, .fromLeft:
            return CGRectOffset(frame, -UIScreen.mainScreen().bounds.size.width, 0)
        case .toBottom, .fromTop:
            return CGRectOffset(frame, 0, -UIScreen.mainScreen().bounds.size.height)
        case .toLeft, .fromRight:
            return CGRectOffset(frame, UIScreen.mainScreen().bounds.size.width, 0)
        }
    }
}

class TranslateAnimator: BaseTransitionAnimator {
    
    private var direction = TranslateTransitionDirection.toRight
    
    func setOriginState(direction:TranslateTransitionDirection) {
        self.direction = direction
    }
    
    override func doForwardTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let containerView = transitionContext.containerView(),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
                return
        }
        
        let finalFrame = transitionContext.finalFrameForViewController(toVC)
        let initialFrame = direction.initialFrame(respectToFinalFrame: finalFrame, forTransitionType: transitionType)
        
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
        let finalFrame = direction.finalFrame(respectToInitialFrame: initialFrame, forTransitionType: transitionType)
        
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