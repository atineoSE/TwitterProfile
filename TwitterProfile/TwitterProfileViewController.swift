//
//  TwitterProfileViewController.swift
//  TwitterProfile
//
//  Created by Adrian Tineo on 20.02.19.
//  Copyright © 2019 adriantineo.com. All rights reserved.
//

import UIKit

class TwitterProfileViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var twitterProfileTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }

    
    private func setupTableView() {
        let tweetCellNib = UINib(nibName: String(describing: TweetTableViewCell.self), bundle: nil)
        twitterProfileTableView.register(tweetCellNib, forCellReuseIdentifier: String(describing: TweetTableViewCell.self))
        let segmentedControlHeaderNib = UINib(nibName: String(describing: SegmentedControlHeaderView.self), bundle: nil)
        twitterProfileTableView.register(segmentedControlHeaderNib, forHeaderFooterViewReuseIdentifier: String(describing: SegmentedControlHeaderView.self))
        
        twitterProfileTableView.sectionHeaderHeight = UITableView.automaticDimension
        twitterProfileTableView.estimatedSectionHeaderHeight = 46.0
        
        twitterProfileTableView.delegate = self
        twitterProfileTableView.dataSource = self
    }

}

