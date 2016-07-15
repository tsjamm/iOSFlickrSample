//
//  GallerySectionHeaderView.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/5/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

/// The header section for the collection view
class GallerySectionHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    //@IBOutlet weak var searchField: UISearchBar!
    
    var isLoading:Bool = false
}
