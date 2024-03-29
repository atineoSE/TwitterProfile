//
//  TwitterProfileViewController+DataSource.swift
//  TwitterProfile
//
//  Created by Adrian Tineo on 20.02.19.
//  Copyright © 2019 adriantineo.com. All rights reserved.
//

import Foundation
import UIKit

extension TwitterProfileViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweetCell = tableView.dequeueReusableCell(withIdentifier: String(describing: TweetTableViewCell.self), for: indexPath) as! TweetTableViewCell
        tweetCell.title = "Tweet " + String(describing: indexPath.row)
        
        return tweetCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        print("debug: new cell for segmented control")
        let segmentedControlHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: SegmentedControlHeaderView.self)) as! SegmentedControlHeaderView
        customSegmentedControl = segmentedControlHeaderView.subviews.last as? CustomSegmentedControl
        customSegmentedControl?.setCustomizedAppearance(usingAutoLayout: true, totalWidth: usableWidth)
        return segmentedControlHeaderView
    }

}
