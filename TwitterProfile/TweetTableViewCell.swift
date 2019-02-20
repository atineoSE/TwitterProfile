//
//  TweetTableViewCell.swift
//  TwitterProfile
//
//  Created by Adrian Tineo on 20.02.19.
//  Copyright © 2019 adriantineo.com. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetLabel: UILabel!
    
    var title: String? {
        didSet {
            tweetLabel.text = title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
