//
//  UIPicplzButton3.swift
//  PicplzClient
//
//  Created by 임영택 on 2/20/25.
//

import UIKit

// FIXME: 공통 디자인 시스템으로 두는게 맞을까
class UIPicplzButton3: UIButton {
    init(title: String, image: UIImage) {
        super.init(frame: .zero)
        var configuration = UIButton.Configuration.plain()
        configuration.background.strokeColor = .grey2
        configuration.background.strokeWidth = 1
        configuration.background.backgroundColor = .grey1
        configuration.cornerStyle = .capsule
        
        configuration.image = image
        configuration.imagePlacement = .leading
        configuration.imagePadding = 3
        
        var attributedTitle = AttributedString(title)
        attributedTitle.font = UIFont.caption
        attributedTitle.foregroundColor = .grey4
        configuration.attributedTitle = attributedTitle
        
        self.configuration = configuration
    }
    
    func changeTitle(_ title: String) {
        var attributedTitle = AttributedString(title)
        attributedTitle.font = UIFont.caption
        attributedTitle.foregroundColor = .grey4
        self.setAttributedTitle(NSAttributedString(attributedTitle), for: .normal)
    }
    
    func changeImage(_ image: UIImage) {
        self.setImage(image, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
