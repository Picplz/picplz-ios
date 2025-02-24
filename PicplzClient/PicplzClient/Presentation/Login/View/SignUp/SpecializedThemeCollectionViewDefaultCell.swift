//
//  SpecializedThemeCollectionViewDefaultCell.swift
//  PicplzClient
//
//  Created by 임영택 on 2/24/25.
//

import UIKit

/**
 픽플즈에서 기본으로 제공하는 감성 항목을 표시하는 셀
 */
class SpecializedThemeCollectionViewDefaultCell: UICollectionViewCell {
    let titleTextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func style() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.isUserInteractionEnabled = false
        
        updateStyle(to: false)

        backgroundColor = .picplzWhite
        layer.borderWidth = 1
        layer.cornerRadius = 5
        clipsToBounds = true
    }
    
    func updateStyle(to isSelected: Bool) {
        if isSelected {
            titleTextField.textColor = .picplzBlack
            titleTextField.font = UIFont(name: FontFamily.pretendardBold.rawValue, size: 14)!
            layer.borderColor = UIColor.picplzBlack.cgColor
        } else {
            titleTextField.textColor = .grey4
            titleTextField.font = UIFont(name: FontFamily.pretendardRegular.rawValue, size: 14)!
            layer.borderColor = UIColor.grey3.cgColor
        }
    }
    
    func layout() {
        addSubview(titleTextField)
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: topAnchor),
            titleTextField.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 12),
            rightAnchor.constraint(greaterThanOrEqualTo: titleTextField.rightAnchor, constant: 12),
            titleTextField.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func configuration(title: String, isSelected: Bool) {
        self.titleTextField.text = title
        updateStyle(to: isSelected)
    }
}
