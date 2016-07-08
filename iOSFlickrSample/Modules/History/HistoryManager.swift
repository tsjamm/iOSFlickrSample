//
//  HistoryManager.swift
//  iOSFlickrSample
//
//  Created by Sai Teja Jammalamadaka on 7/8/16.
//  Copyright © 2016 tsjamm. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryManager {
    
    static var historyList = [String]()
    
    static func showHistoryView() {
        if let historyVC = UIStoryboard(name: "History", bundle: nil).instantiateViewControllerWithIdentifier(Constants.StoryBoardVCID.HistoryViewController.rawValue) as? HistoryViewController {
            
            updateHistoryList()
            
            historyVC.navigationItem.title = "Your History"
            let transitionAnimator = TranslateAnimator()
            transitionAnimator.setOriginState(Constants.TransitionDirection.LeftToRight)
            historyVC.transitionAnimator = transitionAnimator
            BaseNavigationController.getInstance().pushViewController(historyVC, animated: true)
        }
    }
    
    static func updateHistoryList() {
        historyList.removeAll()
        do {
            let realm = try Realm()
            let rFRList = realm.objects(RealmFlickrResponse.self)
            for rFR in rFRList {
                let searchTerm = rFR.searchTerm
                historyList.append(searchTerm)
            }
        } catch {
            NSLog("Error:\n\(error)")
        }
        
    }
    
    static func deleteSearch(indexPath:NSIndexPath) {
        let row = indexPath.row
        let searchTerm = historyList[row]
        historyList.removeAtIndex(row)
        FlickrResponse.deleteFromRealm(searchTerm)
    }
    
    static func clearAllSearchesFromDB() {
        do {
            let realm = try Realm()
            try realm.write({
                realm.deleteAll()
            })
            
        } catch {
            NSLog("Error:\n\(error)")
        }
    }
    
    static func getNumberOfSections() -> Int {
        return 1
    }
    
    static func getNumberOfRows(section:Int) -> Int {
        return historyList.count
    }
    
    static func getSearchTerm(indexPath:NSIndexPath) -> String {
        let row = indexPath.row
        return historyList[row]
    }
    
    static func didSelectRow(indexPath:NSIndexPath) {
        let searchTerm = getSearchTerm(indexPath)
        GalleryManager.showGalleryView(searchTerm)
    }
    
}