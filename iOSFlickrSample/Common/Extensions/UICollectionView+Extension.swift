//
//  UICollectionView+Extension.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/7/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func getRelativeCellFrameInSuperView(indexPath:NSIndexPath) -> CGRect? {
        
        if let atrb = self.layoutAttributesForItemAtIndexPath(indexPath) {
            let cellRect = atrb.frame
            let cellFrameInSuperView = self.convertRect(cellRect, toView: self.superview)
            
            return cellFrameInSuperView
            
        }
        
        return nil
    }
    
}