//
//  BaseViewController.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/7/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

class BaseViewController:UIViewController {
    
    var transitionAnimator:BaseTransitionAnimator?
    var percentDriven: UIPercentDrivenInteractiveTransition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.transitioningDelegate = self
    }
    
    func popCurrentVC(isInteractive: Bool = false) {
        
        if let nVC = self.navigationController {
            nVC.popViewControllerAnimated(true)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func pushVContoCurrentVC(newVC: UIViewController, isInteractive: Bool = false) {
        
        if let nVC = self.navigationController {
            nVC.pushViewController(newVC, animated: true)
        } else {
            self.presentViewController(newVC, animated: true, completion: nil)
        }
    }
    
    func interactivePopForGestureRecognizer(gestureRecognizer:UIGestureRecognizer) {
        if let edgePanGR = gestureRecognizer as? UIScreenEdgePanGestureRecognizer {
            interactiveTransitionForEdgePanGesture(edgePanGR) {
                self.popCurrentVC(true)
            }
        } else if let panGR = gestureRecognizer as? UIPanGestureRecognizer {
            interactiveTransitionForPanGesture(panGR) {
                self.popCurrentVC(true)
            }
        }
    }
    
    func interactivePushForGestureRecognizer(newVC: UIViewController, gestureRecognizer:UIGestureRecognizer) {
        if let edgePanGR = gestureRecognizer as? UIScreenEdgePanGestureRecognizer {
            interactiveTransitionForEdgePanGesture(edgePanGR) {
                self.pushVContoCurrentVC(newVC, isInteractive: true)
            }
        } else if let panGR = gestureRecognizer as? UIPanGestureRecognizer {
            interactiveTransitionForPanGesture(panGR) {
                self.pushVContoCurrentVC(newVC, isInteractive: true)
            }
        }
    }
    
    private func interactiveTransitionForPanGesture(panGR: UIPanGestureRecognizer, beginBlock: (()->())) {
        let distance = panGR.translationInView(self.view).y
        let ratio =  min((distance > 0 ? (distance/100) : ((-1)*distance/100)), 0.99)
        
        switch panGR.state {
        case UIGestureRecognizerState.Began:
            percentDriven = UIPercentDrivenInteractiveTransition()
            beginBlock()
        case UIGestureRecognizerState.Cancelled,
             UIGestureRecognizerState.Ended,
             UIGestureRecognizerState.Failed:
            if ratio >= 0.6 {
                percentDriven?.finishInteractiveTransition()
            } else {
                percentDriven?.cancelInteractiveTransition()
            }
            percentDriven = nil
        case UIGestureRecognizerState.Changed:
            percentDriven?.updateInteractiveTransition(ratio)
        default: break
        }
    }
    
    private func interactiveTransitionForEdgePanGesture(edgePanGR: UIScreenEdgePanGestureRecognizer, beginBlock:(()->())) {
        let distance = edgePanGR.translationInView(self.view).x
        let location = edgePanGR.locationInView(self.view).x
        let displacement = location + distance
        //let viewWidth = self.view.frame.width
        
        let ratio =  min((distance > 0 ? (distance/displacement) : ((-1)*distance/displacement)), 0.99)
        //print("ratio=\(ratio) ... distance=\(distance) ... location=\(location) ... displacement=\(displacement) ... viewWidth=\(viewWidth)")
        
        switch edgePanGR.state {
        case UIGestureRecognizerState.Began:
            percentDriven = UIPercentDrivenInteractiveTransition()
            beginBlock()
        case UIGestureRecognizerState.Cancelled,
             UIGestureRecognizerState.Ended,
             UIGestureRecognizerState.Failed:
            if ratio >= 0.5 {
                percentDriven?.finishInteractiveTransition()
            } else {
                percentDriven?.cancelInteractiveTransition()
            }
            
            percentDriven = nil
        case UIGestureRecognizerState.Changed:
            percentDriven?.updateInteractiveTransition(ratio)
        default: break
        }
    }
    
    
}


extension BaseViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let tA = self.transitionAnimator else {return nil}
        tA.transitionType = BaseTransitionType.present(.regular)
        return tA
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let tA = self.transitionAnimator else {return nil}
        tA.transitionType = BaseTransitionType.dismiss(.regular)
        return tA
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return percentDriven
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return percentDriven
    }
}