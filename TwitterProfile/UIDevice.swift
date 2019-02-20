//
//  UIDevice.swift
//  TwitterProfile
//
//  Created by Adrian Tineo on 20.02.19.
//  Copyright © 2019 adriantineo.com. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    class var belongsToIPhoneXFamily: Bool {
        return UIDevice.current.name.contains("iPhone X")
    }
    
    class var isLandscape: Bool {
        switch (UIDevice.current.orientation) {
        case .faceDown:
            return false
        case .faceUp:
            return false
        case .landscapeLeft:
            return true
        case .landscapeRight:
            return true
        case .portrait:
            return false
        case .portraitUpsideDown:
            return false
        case .unknown:
            return false
        }
    }
}
