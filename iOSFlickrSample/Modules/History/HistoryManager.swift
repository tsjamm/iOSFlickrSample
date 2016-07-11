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
    
    private static var historyList = [String]()
    
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
    
    static func getUpdatedHistoryList() -> [String] {
        updateHistoryList()
        return self.historyList
    }
    
    static func deleteSearch(indexPath:NSIndexPath) {
        let row = indexPath.row
        let searchTerm = historyList[row]
        historyList.removeAtIndex(row)
        FlickrRealmManager.deleteFlickrResponseFromRealm(searchTerm)
    }
    
    static func clearAllSearchesFromDB() {
        FlickrDataManager.clearAllFlickrData()
        GalleryManager.clearSearch()
    }
    
}