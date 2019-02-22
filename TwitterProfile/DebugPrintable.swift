//
//  DebugPrintable.swift
//  TwitterProfile
//
//  Created by Adrian Tineo on 22.02.19.
//  Copyright © 2019 adriantineo.com. All rights reserved.
//

import Foundation

protocol DebugPrintable {
    var debugging: Bool {get set}
}

extension DebugPrintable {
    func debugPrint(_ text: String) {
        if (debugging) {
            print(text)
        }
    }
}
