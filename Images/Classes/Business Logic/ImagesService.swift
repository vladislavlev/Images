//
//  ImagesService.swift
//  Images
//
//  Created by Andrew Vladislavlev on 23.06.17.
//  Copyright © 2017 mac. All rights reserved.
//

import Foundation
import UIKit

class ImagesService {
    
    private static let pendingOperations = PendingOperations()
    
    static func fetchImages() -> [ImageRecord] {
        
        var array: [ImageRecord] = []
        for i in 1..<numberOfImages + 1 {
            let imageURL = URL(string:url + String(i))
            let photoRecord = ImageRecord(url:imageURL!)
            array.append(photoRecord)
        }
        return array
    }
    
    static func startDownloadForRecord(_ photoDetails: ImageRecord, tableView: UITableView, indexPath: IndexPath )
    {
        if let _ = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        
        let downloader = ImageDownloader(imageRecord: photoDetails)
        downloader.completionBlock = { [unowned downloader] in
            if downloader.isCancelled {
                return
            }
            DispatchQueue.main.async(execute: {
                
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                tableView.reloadRows(at: [indexPath], with: .fade)
            })
        }
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    static func cancelDownloadingForIndexPath(indexPath: IndexPath) {
        
        if let operation = self.pendingOperations.downloadsInProgress[indexPath] {
            
            operation.cancel()
            pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
        }
    }
}
