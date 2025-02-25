//
//  UIPickplzButton.swift
//  PicplzClient
//
//  Created by 임영택 on 2/20/25.
//

import UIKit

class UIPickplzButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel?.font = .buttonTitle
        self.backgroundColor = .picplzBlack
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.backgroundColor = .picplzBlack
            } else {
                self.backgroundColor = .grey3
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        setTitleColor(.grey2, for: state)
    }
}
