//
//  Extensions.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/4/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

// This File Contains common extensions for addition functionality


var LoadingViewAssociatedObjectHandle: UInt8 = 0
/// This is for Loading View (Small black square with activity indicator
extension UIView {
    
    var loadingView:UIView? {
        get {
            return objc_getAssociatedObject(self, &LoadingViewAssociatedObjectHandle) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &LoadingViewAssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
    }
    func showLoadingView() {
        if let lV = self.loadingView {
            self.addSubview(lV)
        } else {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
            activityIndicator.startAnimating()
            let boxHalfSide = CGFloat(24)
            let boxSide = 2*boxHalfSide
            let centerX = self.frame.width/2
            let centerY = self.frame.height/2
            let frame = CGRectMake(centerX - boxHalfSide, centerY - boxHalfSide, boxSide, boxSide)
            let lView = UIView(frame: frame)
            lView.layer.cornerRadius = 6.0
            activityIndicator.frame = CGRectMake(0, 0, boxSide, boxSide)
            lView.addSubview(activityIndicator)
            lView.backgroundColor = UIColor.blackColor()
            lView.clipsToBounds = true
            lView.autoresizesSubviews = true
            self.loadingView = lView
            self.addSubview(lView)
        }
        
    }
    func removeLoadingView() {
        if let lV = self.loadingView {
            lV.removeFromSuperview()
        }
    }
}


/// This is for animating a view
extension UIView {
    
    func animateToFrame(newFrame:CGRect, callback:(()->())) {
        
        UIView.animateWithDuration(0.4, animations: {
            self.frame = newFrame
            
            }) { (animationComplete) in
                if animationComplete {
                    callback()
                }
        }
    }
    
}