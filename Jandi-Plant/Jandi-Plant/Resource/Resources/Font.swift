//
//  Font.swift
//
//
//  Created by MEGA_Mac on 8/12/24.
//

import SwiftUI

public extension Font {
    static func pretendardEL(_ size: CGFloat) -> Font {
        Font.custom(FontType.extraLight.rawValue, size: size)
    }
    
    static func pretendardL(_ size: CGFloat) -> Font {
        Font.custom(FontType.light.rawValue, size: size)
    }
    
    static func pretendardR(_ size: CGFloat) -> Font {
        Font.custom(FontType.regular.rawValue, size: size)
    }
    
    static func pretendardM(_ size: CGFloat) -> Font {
        Font.custom(FontType.medium.rawValue, size: size)
    }
    
    static func pretendardEB(_ size: CGFloat) -> Font {
        Font.custom(FontType.extraBold.rawValue, size: size)
    }
    
    static func pretendardB(_ size: CGFloat) -> Font {
        Font.custom(FontType.bold.rawValue, size: size)
    }
    
    static func pretendardSB(_ size: CGFloat) -> Font {
        Font.custom(FontType.semibold.rawValue, size: size)
    }
    
    static func pretendardT(_ size: CGFloat) -> Font {
        Font.custom(FontType.thin.rawValue, size: size)
    }
    
    static func pretendardBL(_ size: CGFloat) -> Font {
        Font.custom(FontType.black.rawValue, size: size)
    }
}
