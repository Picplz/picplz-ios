//
//  PhotographerDetailButton.swift
//  PicplzClient
//
//  Created by 임영택 on 5/5/25.
//

import UIKit

final class PhotographerDetailButton: UIButton {
    init(title: String, image: UIImage) {
        super.init(frame: .zero)
        var configuration = UIButton.Configuration.plain()
        configuration.background.strokeWidth = 1
        configuration.background.backgroundColor = .grey2
        configuration.background.cornerRadius = 5
        
        configuration.image = image
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 4
        
        configuration.contentInsets = .init(top: 2, leading: 7, bottom: 2, trailing: 7)
        
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
