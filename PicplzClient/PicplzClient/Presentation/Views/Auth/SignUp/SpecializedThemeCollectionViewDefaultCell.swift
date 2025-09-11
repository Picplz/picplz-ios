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
    var theme: Theme?

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

        backgroundColor = .ppWhite
        layer.borderWidth = 1
        layer.cornerRadius = 5
        clipsToBounds = true
    }

    func updateStyle(to isSelected: Bool) {
        if isSelected {
            titleTextField.textColor = .ppBlack
            titleTextField.font = UIFont(name: CustomFontFamily.pretendardBold.rawValue, size: 14)!
            layer.borderColor = UIColor.ppBlack.cgColor
        } else {
            titleTextField.textColor = .ppGrey4
            titleTextField.font = UIFont(name: CustomFontFamily.pretendardRegular.rawValue, size: 14)!
            layer.borderColor = UIColor.ppGrey3.cgColor
        }
    }

    func layout() {
        contentView.addSubview(titleTextField)
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            contentView.rightAnchor.constraint(greaterThanOrEqualTo: titleTextField.rightAnchor, constant: 12),
            titleTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configuration(theme: Theme?, isSelected: Bool) {
        guard let theme = theme else { return }
        self.theme = theme
        self.titleTextField.text = theme.title
        updateStyle(to: isSelected)
    }
}
