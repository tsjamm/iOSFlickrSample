//
//  HistoryViewModel.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/10/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

class HistoryViewModel: HistoryViewDataSource {
    
    private let numberOfSections = 1
    private var numberOfRows:Int!
    private var historyList:[String]
    
    init(historyList:[String]) {
        self.historyList = historyList
        self.numberOfRows = historyList.count
    }
    
    func getNumberOfSections() -> Int {
        return numberOfSections
    }
    
    func getNumberOfRowsForSection(section: Int) -> Int {
        return numberOfRows
    }
    
    func configureCellAtIndexPath(tableView: UITableView, cell: UITableViewCell, indexPath: NSIndexPath) {
        cell.textLabel?.text = historyList[indexPath.row]
    }
}
