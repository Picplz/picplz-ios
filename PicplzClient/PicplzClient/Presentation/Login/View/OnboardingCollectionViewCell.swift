//
//  OnboardingCollectionViewCell.swift
//  PicplzClient
//
//  Created by 임영택 on 2/9/25.
//

import UIKit

final class OnboardingCollectionViewCell: UICollectionViewCell {
    let onboardingImageView = UIImageView()
    let onboardingMessageLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupStyle() {
        onboardingImageView.translatesAutoresizingMaskIntoConstraints = false
        onboardingImageView.backgroundColor = Colors.grey1 // temp
        
        onboardingMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        onboardingMessageLabel.font = Fonts.titleBig
        onboardingMessageLabel.numberOfLines = 0
    }
    
    private func setupLayout() {
        addSubview(onboardingImageView)
        NSLayoutConstraint.activate([
            onboardingImageView.topAnchor.constraint(equalTo: topAnchor),
            onboardingImageView.leftAnchor.constraint(equalTo: leftAnchor),
            onboardingImageView.rightAnchor.constraint(equalTo: rightAnchor),
            onboardingImageView.heightAnchor.constraint(equalTo: onboardingImageView.widthAnchor, multiplier: 6.0 / 5.0),
        ])
        
        addSubview(onboardingMessageLabel)
        NSLayoutConstraint.activate([
            onboardingMessageLabel.topAnchor.constraint(equalToSystemSpacingBelow: onboardingImageView.bottomAnchor, multiplier: 4),
            onboardingMessageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            onboardingMessageLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func configure(page: OnboardingPage) {
//        onboardingImageView.image = UIImage(named: page.onboardingImageName) // TODO: Set Image
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .center
        
        let attributedString = NSMutableAttributedString(string: page.onboardingMessage)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        onboardingMessageLabel.attributedText = attributedString
        
        invalidateIntrinsicContentSize()
    }
}
