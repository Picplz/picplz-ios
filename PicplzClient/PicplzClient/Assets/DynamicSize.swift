//
//  DynamicSize.swift
//  PicplzClient
//
//  Created by 임영택 on 7/8/25.
//

import Foundation
import UIKit

/**
 하이파이 디자인의 사이즈를 디바이스 크기에 맞게 변환하는 객체
 */
struct DynamicSize {
    private static let baseWidth: CGFloat = 375.0 // iPhone 12 mini
    
    static var factor: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return screenWidth / baseWidth
    }
    
    /// 디자인 상의 사이즈를 디바이스를 고려한 사이즈로 변환한다
    static func from(_ originalSize: CGFloat) -> CGFloat {
        originalSize * factor
    }
}
