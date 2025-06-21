//
//  Divider.swift
//  PicplzClient
//
//  Created by 임영택 on 5/5/25.
//

import UIKit

final class DividerView: UIView {
    init(backgroundColor: UIColor) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
