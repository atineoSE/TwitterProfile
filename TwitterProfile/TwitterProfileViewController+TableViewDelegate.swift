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
            blurView.alpha = min(-offset/fadingHeight, 1.0)
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
    
    private func updateArrowImageView(by offset: CGFloat) {
        if (!arrowAnimationWasConfigured) {
            arrowImageView.alpha = min(-offset/fadingHeight, 1.0)
        }
    }
    
    private func configureArrowAnimation() {
        arrowAnimationWasConfigured = true
        arrowAnimator?.addAnimations { [weak self] in
            self?.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        arrowAnimator?.addCompletion({ [weak self] _ in
            guard let weakSelf = self else {
                return
            }
            weakSelf.headerActivityIndicator.alpha = 1.0
            weakSelf.arrowImageView.alpha = 0.0
            weakSelf.arrowImageView.transform = CGAffineTransform(rotationAngle: 2*CGFloat.pi)
            weakSelf.headerActivityIndicator.startAnimating()
            let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            selectionFeedbackGenerator.selectionChanged()
        })
    }
    
    private func animateArrowImageView(by offset: CGFloat) {
        if (offset < -pullToRefreshHeight) {
            if let animator = arrowAnimator,
                !arrowAnimationWasConfigured {
                configureArrowAnimation()
                animator.startAnimation()
            }
        }
    }
    
    private func hideActivityIndicator(scrollView: UIScrollView) {
        if (headerActivityIndicator.isAnimating && !networkCallScheduled) {
            // simulate slow network response
            networkCallScheduled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                print("in closure")
                guard let weakSelf = self else {
                    return
                }
                //programmatically shrink the header, i.e. scroll passed the tableHeaderView
                weakSelf.headerActivityIndicator.alpha = 0.0
                weakSelf.headerActivityIndicator.stopAnimating()
                scrollView.setContentOffset(CGPoint(x: 0.0, y: weakSelf.tableViewHeaderView.frame.height), animated: true)
                weakSelf.networkCallScheduled = false
                weakSelf.arrowAnimationWasConfigured = false
            }
        }
    }
    
    private func updateUI(offset: CGFloat, scrollView: UIScrollView) {
        if (offset >= 0) {
            pushUpHeaderView(by: offset)
            updateProfileView(by: offset)
            updateUsernameLabelView(by: offset)
            hideActivityIndicator(scrollView: scrollView)
        } else {
            stretchHeaderView(by: offset)
            resetProfileView()
            updateArrowImageView(by: offset)
            animateArrowImageView(by: offset)
        }
        blurHeaderView(by: offset)
        updateProfileViewRoundedCorners()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        print("offset = \(offset)")
        updateUI(offset: offset, scrollView: scrollView)
    }
    
}
