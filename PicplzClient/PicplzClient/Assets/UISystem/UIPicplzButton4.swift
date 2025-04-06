//
//  UIPicplzButton2.swift
//  PicplzClient
//
//  Created by 임영택 on 2/20/25.
//

import UIKit

// FIXME: 공통 디자인 시스템으로 두는게 맞을까
class UIPicplzButton4: UIButton {
    override var isSelected: Bool {
        didSet {
            guard let nsAttributedTitle = self.attributedTitle(for: .normal) else {
                return
            }
            
            var attributedTitle = AttributedString(nsAttributedTitle)
            attributedTitle.foregroundColor = isSelected ? .black : .grey4
            
            self.setAttributedTitle(NSAttributedString(attributedTitle), for: .normal)
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        var configuration = UIButton.Configuration.plain()
        configuration.background.strokeColor = .black
        configuration.background.strokeWidth = 1
        configuration.background.backgroundColor = .picplzWhite
        configuration.cornerStyle = .medium
        
        var attributedTitle = AttributedString(title)
        attributedTitle.font = UIFont.bodySemibold
        attributedTitle.foregroundColor = .grey4
        configuration.attributedTitle = attributedTitle
        
        self.configuration = configuration
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.tintColor = .grey4
    }
    
    func changeTitle(_ title: String, isToggled: Bool) {
        var attributedTitle = AttributedString(title)
        attributedTitle.font = UIFont.body
        
        if isToggled {
            attributedTitle.foregroundColor = .picplzBlack
        } else {
            attributedTitle.foregroundColor = .grey4
        }
        
        self.setAttributedTitle(NSAttributedString(attributedTitle), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
