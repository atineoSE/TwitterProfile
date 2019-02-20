//
//  CustomSegmentedControl.swift
//  TwitterProfileAxelKee
//
//  Created by Adrian Tineo on 12.02.19.
//  Copyright © 2019 adriantineo.com. All rights reserved.
//


// Based on Kevin Farst's playground at https://www.codementor.io/kevinfarst/designing-a-button-bar-style-uisegmentedcontrol-in-swift-cg6cf0dok

import UIKit

class CustomSegmentedControl: UISegmentedControl {
    private var segmentBar: UIView?
    private var selectedColor: UIColor?
    private var segmentBarLeadingConstraint: NSLayoutConstraint?
    private var segmentBarWidthConstraint: NSLayoutConstraint?
    private var usingAutoLayout: Bool = true
    
    // If instantiating from code
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
    }
    
    // If instantiating from Xib/Storyboard
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func adjustSegment(totalWidth: CGFloat) {
        setSegmentWidth(totalWidth: totalWidth)
        updateSegmentBar()
    }
    
    func setCustomizedAppearance(usingAutoLayout: Bool, totalWidth: CGFloat) {
        self.usingAutoLayout = usingAutoLayout
        selectedColor = tintColor
        setStyle()
        setupSegmentBar()
        adjustSegment(totalWidth: totalWidth)
        setupOffsetAndWidthForSegmentBar(usingAutoLayout: usingAutoLayout)
    }
    
    private func setStyle() {
        // Clear default style
        backgroundColor = .white
        tintColor = .clear
        
        // Define new style
        setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18.0),
            NSAttributedString.Key.foregroundColor: selectedColor ?? UIColor.blue
            ], for: .selected)
        setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18.0),
            NSAttributedString.Key.foregroundColor: UIColor(red: 104/255, green: 118/255, blue: 132/255, alpha: 1.0)
            ], for: .normal)
    }
    
    private func setSegmentWidth(totalWidth: CGFloat) {
        // Discussion:
        // Setting apportionsSegmentWidthsByContent = true in code or auto sizing in IB at the Size inspector
        // we can enable auto sizing of segment width proportional to label widths.
        //
        // In that case widthForSegment(at: selectedSegmentIndex) returns always 0.0
        // (both with and without Auto Layout at the level of segmented control).
        // From the docs: "If the value is {0.0}, UISegmentedControl automatically sizes the segment."
        //
        // Automatic sizing is the default unless specifying segment width manually.
        // Therefore I am calculating geometry manually, for the sake of being able to retrieve segment width
        // when setting/updating bar width/offset.

        var segmentWidths: [CGFloat] = []
        for idx in 0..<numberOfSegments {
            let label = UILabel()
            label.text = titleForSegment(at: idx)
            label.font = UIFont.systemFont(ofSize: 17.0)
            label.sizeToFit()
            segmentWidths.append(label.frame.width)
        }
        
        let segmentWidthCombined = segmentWidths.reduce(0.0) { (partialSum, currentVal) -> CGFloat in
            return partialSum + currentVal
        }
        // Formula:
        // total_width = frame.width = 2*P+L0 + 2*P+L1 + ... + 2*P+Ln = (L0+L1+...Ln) + 2*P*n
        let defaultPadding: CGFloat = 8.0
        let limit = 2.0*CGFloat(numberOfSegments)*defaultPadding + segmentWidthCombined
        
        //print("totalWidth = \(totalWidth)")
        //print("segmentWidthCombined = \(segmentWidthCombined)")
        //print("limit = \(limit)")
        
        if (limit < totalWidth) {
            // It fits alright, get padding space
            let padding = (totalWidth - segmentWidthCombined) / (2*CGFloat(numberOfSegments))
            for idx in 0..<numberOfSegments {
                let width = segmentWidths[idx] + 2*padding
                //print("Loose fit: Fitting segment \(idx) with padding \(padding) and width \(width)")
                setWidth(width, forSegmentAt: idx)
            }
        } else {
            // Not everything will fit, just apply 8.0 for padding and let longest segment be truncated
            let segmentWidthCombinedAndShortened = totalWidth - 2*defaultPadding*CGFloat(numberOfSegments)
            let averageSegmentWidth = segmentWidthCombinedAndShortened / CGFloat(numberOfSegments)
            // Assign width for short labels (width less than average)
            var remainingSegmentIndices: [Int] = []
            var assignedSegmentWidth: CGFloat = 0.0
            for idx in 0..<numberOfSegments {
                if (segmentWidths[idx] < averageSegmentWidth) {
                    let width = segmentWidths[idx]
                    //print("Tight fight (below avg): Fitting segment \(idx) with padding \(defaultPadding) and width \(width)")
                    setWidth(width, forSegmentAt: idx)
                    assignedSegmentWidth += segmentWidths[idx]
                } else {
                   remainingSegmentIndices.append(idx)
                }
            }
            let availableWidth = segmentWidthCombinedAndShortened - assignedSegmentWidth
            let averageAvailableWidth = availableWidth / CGFloat(remainingSegmentIndices.count)
            for idx in remainingSegmentIndices {
                //let width = averageAvailableWidth
                //print("Tight fight (above avg): Fitting segment \(idx) with padding \(defaultPadding) and width \(width)")
                setWidth(averageAvailableWidth, forSegmentAt: idx)
            }
        }
    }
    
    private func setupSegmentBar() {
        segmentBar = UIView()
        guard let segmentBar = segmentBar else {
            return
        }
        
        segmentBar.backgroundColor = selectedColor
        addSubview(segmentBar)
        
        addTarget(self, action: #selector(updateSegmentBar), for: .valueChanged)
    }
    
    private func setupOffsetAndWidthForSegmentBar(usingAutoLayout: Bool) {
        if let segmentBar = segmentBar {
            if (usingAutoLayout) {
                segmentBar.translatesAutoresizingMaskIntoConstraints = false
                
                segmentBar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                segmentBar.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
                
                let offset = horizontalOffset(at: selectedSegmentIndex)
                //print("offset = \(offset)")
                segmentBarLeadingConstraint = NSLayoutConstraint(item: segmentBar, attribute: .leading, relatedBy: .equal, toItem: self.superview, attribute: .leading, multiplier: 1.0, constant: offset)
                segmentBarLeadingConstraint?.isActive = true
                
                let width = widthForSegment(at: selectedSegmentIndex)
                //print("width = \(width)")
                segmentBarWidthConstraint = NSLayoutConstraint(item: segmentBar, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width)
                segmentBarWidthConstraint?.isActive = true
            } else {
                segmentBar.translatesAutoresizingMaskIntoConstraints = true
                segmentBar.frame = CGRect(x: 0.0, y: frame.height - 2.0, width: widthForSegment(at: selectedSegmentIndex), height: 2.0)
            }
        }
    }
    
    private func horizontalOffset(at segmentIndex: Int) -> CGFloat {
        var offset: CGFloat = 0.0
        for idx in 0..<selectedSegmentIndex {
            offset += widthForSegment(at: idx)
        }
        return offset
    }
    
    @objc private func updateSegmentBar() {
        if (usingAutoLayout) {
            UIView.animate(withDuration: 0.3) { [weak self] in
                if let weakSelf = self,
                    let segmentBarLeadingConstraint = weakSelf.segmentBarLeadingConstraint,
                    let segmentBarWidthConstraint = weakSelf.segmentBarWidthConstraint {
                    
                    let offset = weakSelf.horizontalOffset(at: weakSelf.selectedSegmentIndex)
                    
                    //print("autoLayout = \(weakSelf.usingAutoLayout), offset = \(offset)")
                    segmentBarLeadingConstraint.constant = offset
                    
                    let width = weakSelf.widthForSegment(at: weakSelf.selectedSegmentIndex)
                    //print("autoLayout = \(weakSelf.usingAutoLayout), width = \(width)")
                    segmentBarWidthConstraint.constant = width
                    
                    weakSelf.layoutIfNeeded()
                }
            }
        } else {
            UIView.animate(withDuration: 0.3) { [weak self] in
                if let weakSelf = self,
                    let segmentBar = weakSelf.segmentBar {
                    
                    let offset = weakSelf.horizontalOffset(at: weakSelf.selectedSegmentIndex)
                    //print("autoLayout = \(weakSelf.usingAutoLayout), offset = \(offset)")
                    segmentBar.frame.origin.x = offset
                    let width = weakSelf.widthForSegment(at: weakSelf.selectedSegmentIndex)
                    //print("autoLayout = \(weakSelf.usingAutoLayout), width = \(width)")
                    segmentBar.frame.size = CGSize(width: width, height: 2.0)
                }
            }
        }
    }
    
}
