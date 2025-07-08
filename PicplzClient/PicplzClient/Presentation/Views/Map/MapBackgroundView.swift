//
//  MapBackgroundView.swift
//  PicplzClient
//
//  Created by 임영택 on 3/12/25.
//

import UIKit

final class MapBackgroundView: UIView {
    private let diameters = [129.62, 239.3, 350.64, 457.0, 584.0]
    
    override func draw(_ rect: CGRect) {
        diameters.forEach { diameter in
            let radius = diameter / 2.0
            let path = UIBezierPath(ovalIn: CGRect(x: bounds.midX - radius, y: bounds.midY - radius, width: diameter, height: diameter))
            UIColor.ppGrey2.setStroke()
            path.lineWidth = 1
            path.stroke()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        .init(width: 600, height: 600)
    }
}
