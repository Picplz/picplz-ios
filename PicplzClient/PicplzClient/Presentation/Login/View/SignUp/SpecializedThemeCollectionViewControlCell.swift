//
//  SpecializedThemeCollectionViewControlCell.swift
//  PicplzClient
//
//  Created by 임영택 on 2/24/25.
//

import UIKit

/**
 사용자 정의 감성 추가 버튼
 */
final class SpecializedThemeCollectionViewControlCell: SpecializedThemeCollectionViewDefaultCell {
    override func style() {
        super.style()
        
        titleTextField.textColor = .grey3
        backgroundColor = .grey1
        layer.borderColor = UIColor.grey3.cgColor
    }
    
    func configuration(title: String, isSelected: Bool) {
        self.titleTextField.text = title
        self.updateStyle(to: isSelected)
    }
}
