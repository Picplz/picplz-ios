//
//  SignUpPhotographerSpecializedThemesSettingVIew.swift
//  PicplzClient
//
//  Created by 임영택 on 2/24/25.
//

import UIKit

final class SignUpPhotographerSpecializedThemesSettingVIew: UIView {
    let titleLabel = UILabel()
    let optionalCaptionLabel = UILabel()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func style() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .title
        titleLabel.textColor = .black
        titleLabel.text = "자신 있는 촬영 감성을 선택 해주세요."
        
        optionalCaptionLabel.translatesAutoresizingMaskIntoConstraints = false
        optionalCaptionLabel.font = .caption
        optionalCaptionLabel.textColor = .ppGrey3
        optionalCaptionLabel.text = "선택"
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layout() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 74.0), // top padding
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
        ])
        
        addSubview(optionalCaptionLabel)
        NSLayoutConstraint.activate([
            optionalCaptionLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 4.0),
            optionalCaptionLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 4.0),
        ])
        
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
