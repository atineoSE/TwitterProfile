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
    @IBOutlet weak var tableViewHeaderView: UIView!
    
    // MARK: - Auto Layout Constraints
    // Discussion:
    // the top constraint is used to displace the header view upwards, when shrinking it
    // the height constraint is used to strecth the header view
    @IBOutlet weak var headerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    // At its compressed state, the header view should be 88.0 high
    // i.e maximum upwards displacement is 138 - 88 = 50
    let maximumHeaderViewDisplacement = CGFloat(50.0)
    
    var defaultHeaderViewHeight: CGFloat?
    
    // MARK: - Custom segmented control
    var customSegmentedControl: CustomSegmentedControl? = nil
    private var horizontalInset: CGFloat {
        if (UIDevice.belongsToIPhoneXFamily) {
            return 44.0
        } else {
            return 0.0
        }
    }
    var usableWidth: CGFloat {
        if (UIDevice.belongsToIPhoneXFamily && UIDevice.isLandscape) {
            return UIScreen.main.bounds.width - 2*horizontalInset
        } else {
           return UIScreen.main.bounds.width
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        prepareUI()
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
    
    private func prepareUI() {
        defaultHeaderViewHeight = headerViewHeightConstraint.constant
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // recalculate custom segmented control when rotating device
        if (UIDevice.isLandscape) {
            // transitioning to wider screen, consider horizontal inset
            customSegmentedControl?.adjustSegment(totalWidth: size.width - 2*horizontalInset)
        } else {
            // transitioning to narrower screen, disregard horizontal inset
            customSegmentedControl?.adjustSegment(totalWidth: size.width)
        }

    }
    

}

