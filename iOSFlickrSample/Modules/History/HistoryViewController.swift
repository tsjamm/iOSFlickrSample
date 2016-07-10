//
//  HistoryViewController.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/8/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

class HistoryViewController: BaseViewController {
    
    @IBOutlet var historyView: HistoryView! {
        didSet {
            historyView.delegate = self
            historyView.dataSource = HistoryViewModel(historyList: HistoryManager.getUpdatedHistoryList())
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let transitionAnimator = TranslateAnimator()
        transitionAnimator.setOriginState(Constants.TransitionDirection.LeftToRight)
        self.transitionAnimator = transitionAnimator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func onClearTap(sender: AnyObject) {
        HistoryManager.clearAllSearchesFromDB()
        self.historyView.dataSource = HistoryViewModel(historyList: HistoryManager.getUpdatedHistoryList())
    }
    
    @IBAction func onEditTap(sender: AnyObject) {
        if self.historyView.tableView.editing {
            self.historyView.tableView.setEditing(false, animated: true)
        } else {
            self.historyView.tableView.setEditing(true, animated: true)
        }
    }
}

extension HistoryViewController: HistoryViewDelegate {
    func didTapOnCellAtIndexPath(tableView: UITableView, indexPath: NSIndexPath) {
        //HistoryManager.didSelectRow(indexPath)
    }
    
    func commitEditingStyleAtIndexPath(tableView: UITableView, editingStyle: UITableViewCellEditingStyle, indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            HistoryManager.deleteSearch(indexPath)
            self.historyView.dataSource = HistoryViewModel(historyList: HistoryManager.getUpdatedHistoryList())
        }
    }
}