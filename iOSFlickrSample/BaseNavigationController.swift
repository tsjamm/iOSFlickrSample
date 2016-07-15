//
//  BaseNavigationController.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/7/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    static var instance:BaseNavigationController? = nil
    var percentDriven: UIPercentDrivenInteractiveTransition?
    
    static func getInstance() -> BaseNavigationController {
        if let toReturn = instance {
            return toReturn
        } else if let toReturn = UIApplication.sharedApplication().keyWindow?.rootViewController as? BaseNavigationController  {
            instance = toReturn
            return toReturn
        } else {
            let toReturn = BaseNavigationController()
            instance = toReturn
            return toReturn
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
}

extension BaseNavigationController: UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation
        operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController
        toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .Push:
            if let baseVC = toVC as? BaseViewController, let animator = baseVC.transitionAnimator  {
                animator.transitionType = BaseTransitionType.present(.regular)
                percentDriven = baseVC.percentDriven
                return animator
            } else {
                percentDriven = nil
            }
        case .Pop:
            if let baseVC = fromVC as? BaseViewController, let animator = baseVC.transitionAnimator  {
                animator.transitionType = BaseTransitionType.dismiss(.regular)
                percentDriven = baseVC.percentDriven
                return animator
            } else {
                percentDriven = nil
            }
        default:
            percentDriven = nil
        }
        
        return nil
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController
        animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return percentDriven
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        percentDriven = nil
    }
    
}
