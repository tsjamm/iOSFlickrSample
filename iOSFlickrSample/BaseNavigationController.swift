//
//  BaseNavigationController.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/7/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    static var instance:BaseNavigationController? = nil
    
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
        
        self.delegate = self
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case UINavigationControllerOperation.Push:
            if let baseVC = toVC as? BaseViewController, let animator = baseVC.transitionAnimator  {
                animator.transitionType = BaseTransitionType.presentDefault
                return animator
            }
        case UINavigationControllerOperation.Pop:
            if let baseVC = fromVC as? BaseViewController, let animator = baseVC.transitionAnimator  {
                animator.transitionType = BaseTransitionType.dismissDefault
                return animator
            }
        default:
            ()
        }
        
        return nil
    }
    
}
