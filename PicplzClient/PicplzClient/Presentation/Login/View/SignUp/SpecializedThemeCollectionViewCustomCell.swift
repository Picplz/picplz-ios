//
//  SpecializedThemeCollectionViewCustomCell.swift
//  PicplzClient
//
//  Created by 임영택 on 2/24/25.
//

import UIKit

/**
 사용자가 정의한 감성 항목을 표시하는 셀
 */
final class SpecializedThemeCollectionViewCustomCell: SpecializedThemeCollectionViewDefaultCell {
    let pencilIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "PencilIcon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func style() {
        super.style()
        
        pencilIconImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layout() {
        super.layout()
        
        addSubview(pencilIconImageView)
        NSLayoutConstraint.activate([
            pencilIconImageView.widthAnchor.constraint(equalToConstant: 12),
            pencilIconImageView.heightAnchor.constraint(equalToConstant: 12),
            pencilIconImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            pencilIconImageView.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 1),
            rightAnchor.constraint(equalTo: pencilIconImageView.rightAnchor, constant: 12),
        ])
    }
}
