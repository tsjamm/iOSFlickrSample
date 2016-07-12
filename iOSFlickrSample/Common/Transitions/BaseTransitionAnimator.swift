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
    case presentDefault
    case dismissDefault
    case present(NSTimeInterval)
    case dismiss(NSTimeInterval)
    
    func transitionDuration() -> NSTimeInterval {
        switch self {
        case let .present(duration):
            return duration
        case let .dismiss(duration):
            return duration
        case .presentDefault:
            return 0.6
        case .dismissDefault:
            return 0.4
        }
    }
}

class BaseTransitionAnimator: NSObject {
    
    var transitionType = BaseTransitionType.presentDefault
    
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
        case .present, .presentDefault:
            doForwardTransition(transitionContext)
        case .dismiss, .dismissDefault:
            doBackwardTransition(transitionContext)
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return transitionType.transitionDuration()
    }
}
