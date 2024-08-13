//
//  File.swift
//  
//
//  Created by MEGA_Mac on 8/12/24.
//

import Foundation
import SwiftUI

enum FontType: String, CaseIterable {
    case black = "Pretendard-Black"
    case bold = "Pretendard-Bold"
    case extraBold = "Pretendard-ExtraBold"
    case extraLight = "Pretendard-ExtraLight"
    case light = "Pretendard-Light"
    case medium = "Pretendard-Medium"
    case regular = "Pretendard-Regular"
    case semibold = "Pretendard-SemiBold"
    case thin = "Pretendard-Thin"
    
    static var installed = false
}

extension FontType {
    static func install() {
        FontType.installed = true
        for each in FontType.allCases {
            if let cfURL = Resources.bundle.url(forResource: each.rawValue, withExtension: "otf") {
                CTFontManagerRegisterFontsForURL(cfURL as CFURL, .process, nil)
            } else {
                assertionFailure("Could not find font:\(each.rawValue) in bundle:\(Resources.bundle)")
            }
        }
    }
}
