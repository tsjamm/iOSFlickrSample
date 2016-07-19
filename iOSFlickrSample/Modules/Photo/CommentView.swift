//
//  CommentView.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/19/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

protocol CommentViewDataSource: class {
    func getNumberOfSections() -> Int
    func getNumberOfRowsForSection(section:Int) -> Int
    func configureCellAtIndexPath(tableView:UITableView, cell:UITableViewCell, indexPath: NSIndexPath)
}

class CommentView: UIView {

    var dataSource: CommentViewDataSource? {
        didSet {
            dispatch_async(dispatch_get_main_queue(), {
                self.reloadTableView()
                self.removeLoadingView()
            })
            
        }
    }
    
    private let reuseIdentifier = "CommentCell"
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    func hide() {
        self.hidden = true
    }
    
    func show() {
        self.hidden = false
    }

}

extension CommentView: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension CommentView: UITableViewDataSource {
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
}