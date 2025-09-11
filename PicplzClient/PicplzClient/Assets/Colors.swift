//
//  Colors.swift
//  PicplzClient
//
//  Created by 임영택 on 2/9/25.
//

import UIKit

/// 미리 정의한 컬러 시스템
extension UIColor {
    static let ppGrey1 = UIColor(red: 242.0 / 255.0, green: 247.0 / 255.0, blue: 251.0 / 255.0, alpha: 1.0) // #F2F7FB
    static let ppGrey2 = UIColor(red: 226.0 / 255.0, green: 231.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0) // #E2E7EB
    static let ppGrey3 = UIColor(red: 172.0 / 255.0, green: 179.0 / 255.0, blue: 185.0 / 255.0, alpha: 1.0) // #ACB3B9
    static let ppGrey4 = UIColor(red: 90.0 / 255.0, green: 106.0 / 255.0, blue: 118.0 / 255.0, alpha: 1.0) // #5A6A76
    static let ppGrey5 = UIColor(red: 70.0 / 255.0, green: 85.0 / 255.0, blue: 97.0 / 255.0, alpha: 1.0) // #465561
    static let ppGrey6 = UIColor(red: 47.0 / 255.0, green: 49.0 / 255.0, blue: 57.0 / 255.0, alpha: 1.0) // #2F3139
    static let ppGreend100 = UIColor(red: 176.0 / 255.0, green: 217.0 / 255.0, blue: 135.0 / 255.0, alpha: 1.0) // #B0D987
    static let ppGreend120 = UIColor(red: 138.0 / 255.0, green: 192.0 / 255.0, blue: 84.0 / 255.0, alpha: 1.0) // #8AC054
    static let ppGreend150 = UIColor(red: 67.0 / 255.0, green: 108.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0) // #436C00
    static let ppWhite = UIColor(red: 254.0 / 255.0, green: 254.0 / 255.0, blue: 254.0 / 255.0, alpha: 1.0) // #FEFEFE
    static let ppBlack = UIColor(red: 14.0 / 255.0, green: 14.0 / 255.0, blue: 15.0 / 255.0, alpha: 1.0) // #0E0E0F
    static let kakaoYellow = UIColor(red: 255.0 / 255.0, green: 235.0 / 255.0, blue: 59.0 / 255.0, alpha: 1.0) // #FFEB3B
}

/// HEX를 통해 UIColor를 인스턴스화하는 헬퍼
extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (without alpha)
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 1) // Default to white in case of an error
        }
        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            alpha: 1.0
        )
    }

    func toHex() -> String? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        guard self.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }

        let rgb: Int = (Int)(r * 255) << 16 |
                       (Int)(g * 255) << 8 |
                       (Int)(b * 255) << 0

        return String(format: "%06X", rgb)
    }
}
