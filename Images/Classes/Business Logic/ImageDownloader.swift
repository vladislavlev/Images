//
//  ImageDownloader.swift
//  Images
//
//  Created by Andrew Vladislavlev on 23.06.17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class ImageDownloader: Operation {
    private let imageRecord: ImageRecord
    
    init(imageRecord: ImageRecord) {
        
        self.imageRecord = imageRecord
    }

    override func main() {
        
        guard !self.isCancelled else {
            return
        }
       
        guard let imageData = try? Data(contentsOf: self.imageRecord.url as URL) else {
            
            self.imageRecord.description = loadingFailedMessage
            
            return
        }
       
        guard !self.isCancelled else {
            return
        }
        
        self.imageRecord.image = UIImage(data:imageData)
    }
}

