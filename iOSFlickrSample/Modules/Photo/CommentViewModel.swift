//
//  CommentViewModel.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/19/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

class CommentViewModel: CommentViewDataSource {
    
    private let numberOfSections = 1
    private let numberOfRows:Int!
    private let commentList:[String]
    
    init(commentList:[String]) {
        self.commentList = commentList
        numberOfRows = commentList.count
    }
    
    func getNumberOfSections() -> Int {
        return numberOfSections
    }
    
    func getNumberOfRowsForSection(section: Int) -> Int {
        return numberOfRows
    }
    
    func configureCellAtIndexPath(tableView: UITableView, cell: UITableViewCell, indexPath: NSIndexPath) {
        cell.textLabel?.text = commentList[indexPath.row]
        cell.detailTextLabel?.text = "name"
    }
}