//
//  ImageRecord.swift
//  Images
//
//  Created by Andrew Vladislavlev on 23.06.17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class ImageRecord {
    let url:URL
    var image: UIImage?
    var description: NSString?
    
    init(url:URL) {
        self.url = url
    }
    
    func createDescriptionForIndexPath(indexPath: IndexPath) {
    
        self.description = "Image \(indexPath.row + 1)" as NSString
    }
}
