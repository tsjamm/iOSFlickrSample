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
    func didTapOnClearHistory()
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
        transitionAnimator.setOriginState(Constants.TransitionDirection.LeftToRight)
        self.transitionAnimator = transitionAnimator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func onClearTap(sender: AnyObject) {
        HistoryManager.clearAllSearchesFromDB()
        self.historyView.dataSource = HistoryViewModel(historyList: HistoryManager.getUpdatedHistoryList())
        delegate?.didTapOnClearHistory()
    }
    
    @IBAction func onEditTap(sender: AnyObject) {
        if self.historyView.tableView.editing {
            self.historyView.tableView.setEditing(false, animated: true)
        } else {
            self.historyView.tableView.setEditing(true, animated: true)
        }
    }
    
    override func performSegueWithIdentifier(identifier: String, sender: AnyObject?) {
        if identifier == Constants.SegueId.GalleryToHistory.rawValue {
            NSLog("HistoryView:: segue with id=\(identifier) being called...")
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
            self.historyView.dataSource = HistoryViewModel(historyList: HistoryManager.getUpdatedHistoryList())
        }
    }
}