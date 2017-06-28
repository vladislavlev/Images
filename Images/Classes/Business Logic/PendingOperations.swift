//
//  PendingOperation.swift
//  Images
//
//  Created by Andrew Vladislavlev on 23.06.17.
//  Copyright © 2017 mac. All rights reserved.
//

import Foundation

class PendingOperations: NSObject {
    lazy var downloadsInProgress = [IndexPath:Operation]()
    lazy var downloadQueue:OperationQueue = {
        var queue = OperationQueue()
        queue.name = downloadQueueName
        return queue
    }()
}
