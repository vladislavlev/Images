
import UIKit

class ViewController: UIViewController {
    
    weak var tableView: UITableView!
    
    fileprivate var images = [ImageRecord]()
    fileprivate let pendingOperations = PendingOperations()
    fileprivate let url = "http://placehold.it/375x150?text="
    fileprivate let numberOfImages = 100
    fileprivate let rowHeight: CGFloat = 100.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Images"
        
        let tableView = UITableView(frame: view.bounds)
        view.addSubview(tableView)
        self.tableView = tableView
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsSelection = false
        fetchImages()
    }
    
    func fetchImages() {
        
        for i in 0..<numberOfImages {
            let imageURL = URL(string:url + String(i))
            let photoRecord = ImageRecord(url:imageURL!)
            self.images.append(photoRecord)
        }
        self.tableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cellIdentifier = "ImageCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        
        let photoDetails = images[indexPath.row]
        cell.imageView?.image = photoDetails.image
        switch (photoDetails.state){
        case .failed:
            cell.textLabel?.text = "Failed to load"
        case .new:
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            cell.accessoryView = indicator
            indicator.startAnimating()
             cell.textLabel?.text = "Loading..."
            if (!tableView.isDragging && !tableView.isDecelerating) {
                self.startDownloadForRecord(photoDetails, indexPath: indexPath)
            }
        case .downloaded:
            cell.textLabel?.text = "Image \(indexPath.row)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return rowHeight
        
    }
    
    // MARK: - UIScrollViewDelegate
   
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        suspendAllOperations()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForOnscreenCells()
            resumeAllOperations()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImagesForOnscreenCells()
        resumeAllOperations()
    }
    
    // MARK: - Operations
    
    func suspendAllOperations () {
        pendingOperations.downloadQueue.isSuspended = true
    }
    
    func resumeAllOperations () {
        
        pendingOperations.downloadQueue.isSuspended = false
    }
    
    func loadImagesForOnscreenCells () {
        if let pathsArray:[IndexPath] = tableView.indexPathsForVisibleRows {
            let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
            var toBeCancelled = allPendingOperations
            let visiblePaths = Set(pathsArray)
            toBeCancelled.subtract(visiblePaths)
            var toBeStarted = visiblePaths
            toBeStarted.subtract(allPendingOperations)
            for indexPath in toBeCancelled {
                if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                    pendingDownload.cancel()
                }
                pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            }
            for indexPath in toBeStarted {
                let indexPath = indexPath as IndexPath
                let recordToProcess = self.images[(indexPath as NSIndexPath).row]
                startDownloadForRecord(recordToProcess, indexPath: indexPath)
            }
        }
    }
    
    
    func startDownloadForRecord(_ photoDetails: ImageRecord, indexPath: IndexPath)
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
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
            })
            
        }
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
}
