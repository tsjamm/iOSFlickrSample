//
//  UICollectionView+Extension.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/7/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

extension UICollectionViewController {
    
    func getRelativeCellFrameInSuperView(indexPath:NSIndexPath) -> CGRect? {
        if let cv = self.collectionView {
            if let atrb = cv.layoutAttributesForItemAtIndexPath(indexPath) {
                let cellRect = atrb.frame
                let cellFrameInSuperView = self.collectionView!.convertRect(cellRect, toView: cv.superview)
                
                return cellFrameInSuperView
                
            }
        }
        return nil
    }
    
}