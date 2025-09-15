//
//  UIPicplzButton2.swift
//  PicplzClient
//
//  Created by 임영택 on 2/20/25.
//

import UIKit

class UIPicplzButton2: UIButton {
    init(title: String, image: UIImage) {
        super.init(frame: .zero)
        var configuration = UIButton.Configuration.plain()
        configuration.background.strokeColor = .ppGrey2
        configuration.background.strokeWidth = 1
        configuration.background.backgroundColor = .white
        configuration.cornerStyle = .capsule

        configuration.image = image
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 3

        var attributedTitle = AttributedString(title)
        attributedTitle.font = .body
        attributedTitle.foregroundColor = .ppGrey4
        configuration.attributedTitle = attributedTitle

        self.configuration = configuration
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
