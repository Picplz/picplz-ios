//
//  Fonts.swift
//  PicplzClient
//
//  Created by 임영택 on 2/9/25.
//

import UIKit
import OSLog

enum CustomFontFamily: String {
    case pretendardExtraBold = "Pretendard-ExtraBold"
    case pretendardBold = "Pretendard-Bold"
    case pretendardSemiBold = "Pretendard-SemiBold"
    case pretendardMedium = "Pretendard-Medium"
    case pretendardRegular = "Pretendard-Regular"
    case pretendardLight = "Pretendard-Light"
    case pretendardExtraLight = "Pretendard-ExtraLight"
    case pretendardThin = "Pretendard-Thin"
}

enum CustomFontTypography {
    case largeTitle
    case title
    case smallTitle
    case largeBody
    case body
    case caption
    case tagContent
    case buttonTitle
    case chatButtonTitle

    var size: CGFloat {
        switch self {
        case .largeTitle:
            24
        case .title:
            20
        case .smallTitle:
            18
        case .largeBody:
            16
        case .body:
            14
        case .caption:
            12
        case .tagContent:
            12
        case .buttonTitle:
            16
        case .chatButtonTitle:
            12
        }
    }

    var lineHeight: CGFloat {
        switch self {
        case .largeTitle, .title, .smallTitle, .largeBody, .body, .caption, .tagContent, .buttonTitle, .chatButtonTitle:
            return 140
        }
    }
}

extension UIFont {
    static let logger = Logger.of("UIFont+")

    static func custom(_ fontFamily: CustomFontFamily, size: CGFloat) -> UIFont {
        if let font = UIFont(name: fontFamily.rawValue, size: size) {
            return font
        } else {
            logger.warning("font not found: \(fontFamily.rawValue)")
            return UIFont.systemFont(ofSize: size)
        }
    }

    static let body = UIFont.custom(.pretendardRegular, size: 14)
    static let bodySemibold = UIFont.custom(.pretendardSemiBold, size: 14)
    static let largeBody = UIFont.custom(.pretendardRegular, size: 16)
    static let buttonTitle = UIFont.custom(.pretendardBold, size: 16)
    static let title = UIFont.custom(.pretendardBold, size: 20)
    static let bigTitle = UIFont.custom(.pretendardBold, size: 24)
    static let smallTitle = UIFont.custom(.pretendardBold, size: 18)
    static let caption = UIFont.custom(.pretendardRegular, size: 12)
    static let captionSemiBold = UIFont.custom(.pretendardSemiBold, size: 12)
    static let middleTitleSemiBold = UIFont.custom(.pretendardSemiBold, size: 18)

#if DEBUG
    static func listFontFamilies() {
        let families = familyNames.reduce("") { partialResult, family in
            partialResult + "\n" + family
        }
        print(families)
    }
#endif
}
