//
//  ImageTableViewCell.swift
//  Images
//
//  Created by Andrew Vladislavlev on 23.06.17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    private let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    func update(withImageRecord imageRecord: ImageRecord) {
        
        self.textLabel?.text = imageRecord.description as String?
        if let image = imageRecord.image {
            self.indicator.stopAnimating()
            self.imageView?.image = image
        } else {
            self.imageView?.image = UIImage(named: "placeholder")
            self.indicator.startAnimating()
            self.accessoryView = indicator
            self.textLabel?.text = loadingMessage
        }
    }
}
