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

    // MARK: Constraints
    private let imageViewHeightMultiplier: CGFloat = 495.0 / 376.0
    private let imageMessageSpacing: CGFloat = 34

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
        onboardingImageView.backgroundColor = .ppGrey1 // temp

        onboardingMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        onboardingMessageLabel.font = .bigTitle
        onboardingMessageLabel.numberOfLines = 0
    }

    private func setupLayout() {
        contentView.addSubview(onboardingImageView)
        contentView.addSubview(onboardingMessageLabel)

        NSLayoutConstraint.activate([
            onboardingImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            onboardingImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            onboardingImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            onboardingImageView.heightAnchor.constraint(equalTo: onboardingImageView.widthAnchor,
                                                        multiplier: imageViewHeightMultiplier)
        ])

        NSLayoutConstraint.activate([
            onboardingMessageLabel.topAnchor.constraint(equalTo: onboardingImageView.bottomAnchor, constant: imageMessageSpacing),
            onboardingMessageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            onboardingMessageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            onboardingMessageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configure(page: OnboardingPage) {
        if let onboardingImage = page.onboardingImage {
            onboardingImageView.image = UIImage(resource: onboardingImage)
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .center

        let attributedString = NSMutableAttributedString(string: page.onboardingMessage)
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )

        onboardingMessageLabel.attributedText = attributedString

        invalidateIntrinsicContentSize()
    }
}
