//
//  TwitterProfileViewController+TableViewDelegate.swift
//  TwitterProfile
//
//  Created by Adrian Tineo on 21.02.19.
//  Copyright © 2019 adriantineo.com. All rights reserved.
//

import Foundation
import UIKit

extension TwitterProfileViewController: UITableViewDelegate {
    
    private func stretchHeaderView(by offset: CGFloat) {
        guard let defaultHeaderViewHeight = defaultHeaderViewHeight else {
            return
        }
        headerViewTopConstraint.constant = 0
        let newHeight = defaultHeaderViewHeight - offset
        print("newHeight = \(newHeight)")
        headerViewHeightConstraint.constant = newHeight
    }

    private func updateUI(offset: CGFloat) {
        if (offset < 0) {
            stretchHeaderView(by: offset)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        print("offset = \(offset)")
        updateUI(offset: offset)
    }
    
}
