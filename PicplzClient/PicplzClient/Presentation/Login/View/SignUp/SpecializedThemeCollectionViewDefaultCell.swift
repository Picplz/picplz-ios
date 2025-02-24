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
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func style() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        updateStyle(to: false)

        backgroundColor = .picplzWhite
        layer.borderWidth = 1
        layer.cornerRadius = 5
        clipsToBounds = true
    }
    
    func updateStyle(to isSelected: Bool) {
        if isSelected {
            titleLabel.textColor = .picplzBlack
            titleLabel.font = UIFont(name: FontFamily.pretendardBold.rawValue, size: 14)!
            layer.borderColor = UIColor.picplzBlack.cgColor
        } else {
            titleLabel.textColor = .grey4
            titleLabel.font = UIFont(name: FontFamily.pretendardRegular.rawValue, size: 14)!
            layer.borderColor = UIColor.grey3.cgColor
        }
    }
    
    func layout() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 12),
            rightAnchor.constraint(greaterThanOrEqualTo: titleLabel.rightAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func configuration(title: String, isSelected: Bool) {
        self.titleLabel.text = title
        updateStyle(to: isSelected)
    }
}
