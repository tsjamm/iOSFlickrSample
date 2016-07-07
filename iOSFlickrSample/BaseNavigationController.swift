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
            if let animator = toVC.transitionAnimator {
                animator.doReverse = false
                return animator
            }
        case UINavigationControllerOperation.Pop:
            if let animator = fromVC.transitionAnimator {
                animator.doReverse = true
                return animator
            }
        default:
            ()
        }
        
        return nil
    }
    
}
