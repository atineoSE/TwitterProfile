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
    @IBOutlet weak var profileDescriptionLabel: UILabel!
    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var profileImageView: DesignableImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    // MARK: - Auto Layout Constraints
    // Discussion:
    // the top constraint is used to displace the header view upwards, when shrinking it
    // the height constraint is used to strecth the header view
    @IBOutlet weak var headerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameLabelBottomConstraint: NSLayoutConstraint!
    
    // At its compressed state, the header view should be 88.0 high
    // i.e maximum upwards displacement is 138 - 88 = 50
    let maximumHeaderViewDisplacement = CGFloat(50.0)
    let maximumUsernameLabelDisplacement = CGFloat(28.0)
    let fadingHeight = CGFloat(25.0)
    var defaultHeaderViewHeight: CGFloat?
    var defaultProfileViewBottomSpacing: CGFloat?
    var defaultProfileViewTopSpacing: CGFloat?
    var defaultUsernameLabelBottomConstraint: CGFloat?
    
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
        
        // Make sure we adapt to dynamic text
        profileDescriptionLabel.text = "Twitter was created in March 2006 by Jack Dorsey, Noah Glass, Biz Stone, and Evan Williams and launched in July of that year."
    }
    
    override func viewDidLayoutSubviews() {
        adjustTableHeaderViewSize()
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
    
    // MARK: - UI adjustments
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
        defaultProfileViewTopSpacing = profileViewTopConstraint.constant
        defaultProfileViewBottomSpacing = profileViewBottomConstraint.constant
        defaultUsernameLabelBottomConstraint = usernameLabelBottomConstraint.constant
    }

    private func adjustTableHeaderViewSize() {
        // Make the header view of the table view to be dynamic height depending on the content inside (eg: the description label)
        
        // UILayoutFittingCompressedSize means use the smallest possible size that can fit the content inside the header view
        let headerSize = tableViewHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        // this check is needed as changing the frame of header view will trigger a new layout cycle, causing viewDidLayoutSubviews to be called again
        // to prevent stuck in a loop, only change frame (ie. calling viewDidLayoutSubviews) when the height of header view havent set to minimum
        if(tableViewHeaderView.frame.size.height != headerSize.height){
            
            // update the height for the table header view
            tableViewHeaderView.frame.size.height = headerSize.height
            
            // this line is needed to trigger the layout update
            twitterProfileTableView.tableHeaderView = tableViewHeaderView
            twitterProfileTableView.layoutIfNeeded()
        }
    }
    
    func putProfileViewInFront() {
        profileContainerView.layer.zPosition = 2.0
        headerView.layer.zPosition = 1.0
    }
    
    func putHeaderViewInFront() {
        profileContainerView.layer.zPosition = 1.0
        headerView.layer.zPosition = 2.0
    }

}

