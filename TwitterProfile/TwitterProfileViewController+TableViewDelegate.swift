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
    
    private func pushUpHeaderView(by offset: CGFloat) {
        guard let defaultHeaderViewHeight = defaultHeaderViewHeight else {
            return
        }
        print("header view top = \(headerViewTopConstraint.constant), header view height = \(headerViewHeightConstraint.constant)")
        headerViewHeightConstraint.constant = defaultHeaderViewHeight
        headerViewTopConstraint.constant = max(-offset, -maximumHeaderViewDisplacement)
    }
    
    private func blurHeaderView(by offset: CGFloat) {
        print("blurView = \(blurView.alpha)")
        if (offset < 0) {
            blurView.alpha = min(-offset / 20.0, 1.0)
        } else if(offset > maximumHeaderViewDisplacement) {
            blurView.alpha = min((offset - maximumHeaderViewDisplacement)/maximumUsernameLabelDisplacement , 1.0)
        }
    }
    
    private func stretchHeaderView(by offset: CGFloat) {
        guard let defaultHeaderViewHeight = defaultHeaderViewHeight else {
            return
        }
        print("header view top = \(headerViewTopConstraint.constant), header view height = \(headerViewHeightConstraint.constant)")
        headerViewTopConstraint.constant = 0
        headerViewHeightConstraint.constant = defaultHeaderViewHeight - offset
    }
    
    private func updateProfileView(by offset: CGFloat) {
        guard let defaultProfileViewBottomSpacing = defaultProfileViewBottomSpacing,
            let defaultProfileViewTopSpacing = defaultProfileViewTopSpacing,
            let defaultHeaderViewHeight = defaultHeaderViewHeight else {
                return
        }
        print("profile view top = \(profileViewTopConstraint.constant); profile view bottom = \(profileViewBottomConstraint.constant)")
        if (offset < maximumHeaderViewDisplacement) {
            // For 0 < offset < maximumHeaderViewDisplacement, slowly reduce top constraint to scale down
            let compressedHeaderHeight = defaultHeaderViewHeight - maximumHeaderViewDisplacement
            let normalizingFactor = (defaultProfileViewTopSpacing - compressedHeaderHeight)/maximumHeaderViewDisplacement
            profileViewTopConstraint.constant = defaultProfileViewTopSpacing - offset*normalizingFactor
            profileViewBottomConstraint.constant = defaultProfileViewBottomSpacing
            putProfileViewInFront()
        } else {
            // For offset >= maximumHeaderViewDisplacement, keep the relationship between top and bottom (keep scale ratio)
            // and just displace up
            profileViewTopConstraint.constant = defaultHeaderViewHeight - maximumHeaderViewDisplacement + maximumHeaderViewDisplacement - offset
            profileViewBottomConstraint.constant = defaultProfileViewBottomSpacing + maximumHeaderViewDisplacement - offset
            putHeaderViewInFront()
        }
    }
    
    private func updateUsernameLabelView(by offset: CGFloat) {
        guard let defaultUsernameLabelBottomConstraint = defaultUsernameLabelBottomConstraint else {
            return
        }
        usernameLabelBottomConstraint.constant = min(defaultUsernameLabelBottomConstraint + offset, maximumUsernameLabelDisplacement)
    }
    
    private func resetProfileView() {
        guard let defaultProfileViewBottomSpacing = defaultProfileViewBottomSpacing,
            let defaultProfileViewTopSpacing = defaultProfileViewTopSpacing else {
                return
        }
        print("profile view top = \(profileViewTopConstraint.constant); profile view bottom = \(profileViewBottomConstraint.constant)")
        profileViewTopConstraint.constant = defaultProfileViewTopSpacing
        profileViewBottomConstraint.constant = defaultProfileViewBottomSpacing
    }

    private func updateProfileViewRoundedCorners() {
        profileImageView.makeRound()
        profileContainerView.makeRound()
    }
    
    private func updateUI(offset: CGFloat) {
        if (offset > 0) {
            pushUpHeaderView(by: offset)
            updateProfileView(by: offset)
            updateUsernameLabelView(by: offset)
        } else {
            stretchHeaderView(by: offset)
            resetProfileView()
        }
        blurHeaderView(by: offset)
        updateProfileViewRoundedCorners()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        print("offset = \(offset)")
        updateUI(offset: offset)
    }
    
}
