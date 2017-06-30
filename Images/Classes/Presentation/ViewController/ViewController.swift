//
//  ViewController.swift
//  Images
//
//  Created by Andrew Vladislavlev on 23.06.17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    fileprivate var images: [ImageRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.images = ImagesService.fetchImages()
        navigationItem.title = title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableCellIdentifier)
            ?? ImageTableViewCell(style: .subtitle, reuseIdentifier: reusableCellIdentifier)
        let photoDetails = images[indexPath.row]
        photoDetails.createDescriptionForIndexPath(indexPath: indexPath)
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
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        ImagesService.cancelDownloadingForIndexPath(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return rowHeight
    }
}
