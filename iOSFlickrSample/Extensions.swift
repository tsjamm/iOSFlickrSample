//
//  Extensions.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/4/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import Foundation

// This File Contains common extensions for addition functionality

var LoadingViewAssociatedObjectHandle: UInt8 = 0
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
            let centerX = self.frame.width/2
            let centerY = self.frame.height/2
            let frame = CGRectMake(centerX - boxHalfSide, centerY - boxHalfSide, boxHalfSide*2, boxHalfSide*2)
            let lView = UIView(frame: frame)
            lView.layer.cornerRadius = 6.0
            activityIndicator.frame = CGRectMake(0, 0, boxHalfSide*2, boxHalfSide*2)
            lView.addSubview(activityIndicator)
            lView.backgroundColor = UIColor.blackColor()
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