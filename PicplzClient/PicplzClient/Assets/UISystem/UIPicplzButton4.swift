//
//  UIPicplzButton2.swift
//  PicplzClient
//
//  Created by 임영택 on 2/20/25.
//

import UIKit

// FIXME: 공통 디자인 시스템으로 두는게 맞을까
class UIPicplzButton4: UIButton {
    init(title: String) {
        super.init(frame: .zero)

        var configuration = UIButton.Configuration.plain()
        configuration.background.strokeColor = .black
        configuration.background.strokeWidth = 1
        configuration.background.backgroundColor = .ppWhite
        configuration.cornerStyle = .medium
        configuration.contentInsets = .init(top: 5, leading: 12, bottom: 5, trailing: 12)
        self.configuration = configuration

        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.tintColor = .ppGrey4

        self.configurationUpdateHandler = { button in
            switch button.state {
            case .selected:
                var attributedTitle = AttributedString(title)
                attributedTitle.font = UIFont.bodySemibold
                attributedTitle.foregroundColor = .ppBlack
                button.configuration?.attributedTitle = attributedTitle
            default:
                var attributedTitle = AttributedString(title)
                attributedTitle.font = UIFont.body
                attributedTitle.foregroundColor = .ppGrey4
                button.configuration?.attributedTitle = attributedTitle
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
