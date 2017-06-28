//
//  ViewController.swift
//  Images
//
//  Created by Andrew Vladislavlev on 23.06.17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    weak private var tableView: UITableView!
    fileprivate var images: [ImageRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.images = ImagesService.fetchImages()
        navigationItem.title = title
        let tableView = UITableView(frame: view.bounds)
        view.addSubview(tableView)
        self.tableView = tableView
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsSelection = false
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableCellIdentifier)
            ?? ImageTableViewCell(style: .subtitle, reuseIdentifier: reusableCellIdentifier)
        let photoDetails = images[indexPath.row]
        photoDetails.description = "Image \(indexPath.row + 1)" as NSString
        (cell as! ImageTableViewCell).update(withImageRecord: photoDetails)
        
        if (photoDetails.image == nil) {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            cell.accessoryView = indicator
            indicator.startAnimating()
            ImagesService.startDownloadForRecord(photoDetails, tableView: tableView, indexPath: indexPath)
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        ImagesService.cancelDownloadingForIndexPath(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return rowHeight
    }
}
