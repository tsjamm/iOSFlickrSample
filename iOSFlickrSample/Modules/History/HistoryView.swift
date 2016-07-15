//
//  HistoryView.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/10/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

protocol HistoryViewDelegate: class {
    func didTapOnCellAtIndexPath(tableView:UITableView, indexPath:NSIndexPath)
    func commitEditingStyleAtIndexPath(tableView: UITableView, editingStyle: UITableViewCellEditingStyle, indexPath: NSIndexPath)
    func onEdgePan(sender:UIScreenEdgePanGestureRecognizer)
}

protocol HistoryViewDataSource: class {
    func getNumberOfSections() -> Int
    func getNumberOfRowsForSection(section:Int) -> Int
    func configureCellAtIndexPath(tableView:UITableView, cell:UITableViewCell, indexPath: NSIndexPath)
}

class HistoryView: UIView {

    var dataSource: HistoryViewDataSource? {
        didSet {
            dispatch_async(dispatch_get_main_queue(), {
                self.reloadTableView()
                self.removeLoadingView()
            })
            
        }
    }
    weak var delegate: HistoryViewDelegate?
    
    private let reuseIdentifier = "HisCell"
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    @IBAction func onEdgePan(sender:UIScreenEdgePanGestureRecognizer) {
        delegate?.onEdgePan(sender)
    }
}

extension HistoryView:UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.didTapOnCellAtIndexPath(tableView, indexPath: indexPath)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
}

extension HistoryView:UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource?.getNumberOfSections() ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.getNumberOfRowsForSection(section) ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        dataSource?.configureCellAtIndexPath(tableView, cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.commitEditingStyleAtIndexPath(tableView, editingStyle: editingStyle, indexPath: indexPath)
    }
}
