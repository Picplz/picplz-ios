//
//  Fonts.swift
//  PicplzClient
//
//  Created by 임영택 on 2/9/25.
//

import UIKit

enum FontFamily: String {
    case pretendardExtraBold = "Pretendard-ExtraBold"
    case pretendardBold = "Pretendard-Bold"
    case pretendardSemiBold = "Pretendard-SemiBold"
    case pretendardMedium = "Pretendard-Medium"
    case pretendardRegular = "Pretendard-Regular"
    case pretendardLight = "Pretendard-Light"
    case pretendardExtraLight = "Pretendard-ExtraLight"
    case pretendardThin = "Pretendard-Thin"
}

extension UIFont {
    static func listFontFamilies() {
        let families = familyNames.reduce("") { partialResult, family in
            return partialResult + "\n" + family
        }
        print(families)
    }
    
    static let body = UIFont(name: FontFamily.pretendardRegular.rawValue, size: 14)!
    static let bodySemibold = UIFont(name: FontFamily.pretendardSemiBold.rawValue, size: 14)!
    static let bigBody = UIFont(name: FontFamily.pretendardRegular.rawValue, size: 16)!
    static let buttonTitle = UIFont(name: FontFamily.pretendardBold.rawValue, size: 16)!
    static let title = UIFont(name: FontFamily.pretendardBold.rawValue, size: 20)!
    static let bigTitle = UIFont(name: FontFamily.pretendardBold.rawValue, size: 24)!
    static let caption = UIFont(name: FontFamily.pretendardRegular.rawValue, size: 12)!
    static let captionSemiBold = UIFont(name: FontFamily.pretendardSemiBold.rawValue, size: 12)!
    static let middleTitleSemiBold = UIFont(name: FontFamily.pretendardSemiBold.rawValue, size: 18)!
}
