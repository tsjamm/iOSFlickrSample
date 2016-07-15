//
//  BaseTransitionAnimator.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/7/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import Foundation
import UIKit

//MARK: TransitionType
enum BaseTransitionType {
    case present(Duration)
    case dismiss(Duration)
    
    func transitionDuration() -> NSTimeInterval {
        switch self {
        case let .present(duration):
            return duration.value()
        case let .dismiss(duration):
            return duration.value()
        }
    }
    
    enum Duration {
        case custom(NSTimeInterval)
        case regular
        
        func value() -> NSTimeInterval {
            switch self {
            case let .custom(duration):
                return duration
            case regular:
                return 0.5
            }
        }
    }
}

class BaseTransitionAnimator: NSObject {
    
    var transitionType = BaseTransitionType.present(.regular)
    
    func doForwardTransition(transitionContext:UIViewControllerContextTransitioning) {
        return
    }
    
    func doBackwardTransition(transitionContext:UIViewControllerContextTransitioning) {
        return
    }
    
}

extension BaseTransitionAnimator: UIViewControllerAnimatedTransitioning {
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        switch transitionType {
        case .present:
            doForwardTransition(transitionContext)
        case .dismiss:
            doBackwardTransition(transitionContext)
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return transitionType.transitionDuration()
    }
}
