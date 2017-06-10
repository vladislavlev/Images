
import UIKit

enum ImageRecordState {
    case new, downloaded, failed
}

class ImageRecord {
    let url:URL
    var state = ImageRecordState.new
    var image = UIImage(named: "Placeholder")
    init(url:URL) {
        self.url = url
    }
}

class PendingOperations: NSObject {
    lazy var downloadsInProgress = [IndexPath:Operation]()
    lazy var downloadQueue:OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        return queue
    }()
}

class ImageDownloader: Operation {
    
    let imageRecord: ImageRecord
    
    init(imageRecord: ImageRecord) {
        self.imageRecord = imageRecord
    }
    
    override func main() {
        
        guard !self.isCancelled else {
            return
        }
        
        guard let imageData = try? Data(contentsOf: self.imageRecord.url as URL) else {
            
            self.imageRecord.image = UIImage(named: "Failed")
            self.imageRecord.state = .failed
            return
        }
        
        guard !self.isCancelled else {
            return
        }
        
        self.imageRecord.image = UIImage(data:imageData)
        self.imageRecord.state = .downloaded
    }
}

