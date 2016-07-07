//
//  UIImageView+Extension.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/7/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImageWithAnimation(newImage:UIImage?) {
        
        let transition = CATransition()
        transition.duration = 0.8
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.layer.addAnimation(transition, forKey: nil)
        
        self.image = newImage
    }
    
}
