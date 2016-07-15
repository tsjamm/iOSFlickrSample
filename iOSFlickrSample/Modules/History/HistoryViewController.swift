//
//  HistoryViewController.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/8/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit

protocol HistoryViewControllerDelegate: class {
    func didTapOnHistoricalSearch(searchTerm: String)
    func searchHistoryCleared()
}

class HistoryViewController: BaseViewController {
    
    @IBOutlet var historyView: HistoryView! {
        didSet {
            historyView.delegate = self
            historyView.dataSource = HistoryViewModel(historyList: HistoryManager.getUpdatedHistoryList())
        }
    }
    weak var delegate: HistoryViewControllerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let transitionAnimator = TranslateAnimator()
        transitionAnimator.setOriginState(TranslateTransitionDirection.fromLeft)
        self.transitionAnimator = transitionAnimator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func onClearTap(sender: AnyObject) {
        HistoryManager.clearAllSearchesFromDB()
        self.historyView.dataSource = HistoryViewModel(historyList: HistoryManager.getUpdatedHistoryList())
        delegate?.searchHistoryCleared()
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
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if let searchTerm = cell.textLabel?.text {
                delegate?.didTapOnHistoricalSearch(searchTerm)
            }
        }
    }
    
    func commitEditingStyleAtIndexPath(tableView: UITableView, editingStyle: UITableViewCellEditingStyle, indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            HistoryManager.deleteSearch(indexPath)
            if HistoryManager.getHistoryCount() == 0 {
                delegate?.searchHistoryCleared()
            }
            self.historyView.dataSource = HistoryViewModel(historyList: HistoryManager.getUpdatedHistoryList())
        }
    }
    
    func onEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        interactivePopForGestureRecognizer(sender)
    }
}