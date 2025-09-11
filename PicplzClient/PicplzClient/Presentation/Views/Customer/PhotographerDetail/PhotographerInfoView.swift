//
//  PhotographerInfoView.swift
//  PicplzClient
//
//  Created by 임영택 on 5/5/25.
//

import UIKit

final class PhotographerInfoView: UIView {
    let followersCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ppGrey4
        label.font = .caption
        return label
    }()

    let followButton: UIButton = {
        let button = PhotographerDetailButton(title: "팔로우", image: UIImage(named: "Plus")!)
        return button
    }()

    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 37
        return imageView
    }()

    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .title
        return nameLabel
    }()

    let snsIcon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    let snsIdLabel: UILabel = {
        let label = UILabel()
        label.font = .caption
        label.textColor = .ppGrey3
        return label
    }()

    let directShootBadge: UIView = {
        let view = UIView()

        // sub-sub views
        let badgeImageView = UIImageView()
        badgeImageView.image = UIImage(named: "CircleSymbol")

        let badgeCaption = UILabel()
        badgeCaption.font = .captionSemiBold
        badgeCaption.textColor = .ppGreend120
        badgeCaption.text = "바로 촬영"

        // layout
        view.addSubview(badgeImageView)
        view.addSubview(badgeCaption)

        badgeImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.height.equalTo(10)
            make.centerY.equalTo(badgeCaption.snp.centerY)
        }

        badgeCaption.snp.makeConstraints { make in
            make.leading.equalTo(badgeImageView.snp.trailing).offset(4)
            make.trailing.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }

        return view
    }()

    let introductionLabel: CustomTruncatedLabel = {
        let normalFont = UIFont(name: CustomFontFamily.pretendardRegular.rawValue, size: 11)!
        let boldFont = UIFont(name: CustomFontFamily.pretendardBold.rawValue, size: 11)!

        let label = CustomTruncatedLabel(ellipsisString: "...더보기", ellipsisFont: boldFont, normalFont: normalFont)
        label.numberOfLines = 2
        return label
    }()

    let divderView: UIView = {
        let view = UIView()
        view.backgroundColor = .ppGrey2
        return view
    }()

    let townsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .captionSemiBold
        label.textColor = .ppBlack
        label.text = "촬영지"
        return label
    }()

    let townsContentLabel: UILabel = {
        let label = UILabel()
        label.font = .caption
        label.textColor = .ppGrey4
        return label
    }()

    let townsExtendImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ChevronLeft")
        return imageView
    }()

    let keywordTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .captionSemiBold
        label.textColor = .ppBlack
        label.text = "키워드"
        return label
    }()

    let keywordContentLabel: UILabel = {
        let label = UILabel()
        label.font = .caption
        label.textColor = .ppGrey4
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .ppWhite
        self.isUserInteractionEnabled = true

        addSubview(followersCountLabel)
        addSubview(followButton)
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(snsIcon)
        addSubview(snsIdLabel)
        addSubview(directShootBadge)
        addSubview(introductionLabel)
        addSubview(divderView)
        addSubview(townsTitleLabel)
        addSubview(townsContentLabel)
        addSubview(townsExtendImage)
        addSubview(keywordTitleLabel)
        addSubview(keywordContentLabel)

        followButton.snp.makeConstraints { make in
            make.top.equalTo(snp.top)
            make.trailing.equalTo(snp.trailing)
        }

        followersCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(followButton)
            make.trailing.equalTo(followButton.snp.leading).offset(-4)
        }

        profileImage.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(22)
            make.leading.equalTo(snp.leading)
            make.height.equalTo(74)
            make.width.equalTo(74)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage)
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
        }

        directShootBadge.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(8)
            make.centerY.equalTo(nameLabel.snp.centerY)
        }

        snsIcon.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.equalTo(nameLabel)
            make.width.equalTo(10)
            make.height.equalTo(10)
        }

        snsIdLabel.snp.makeConstraints { make in
            make.leading.equalTo(snsIcon.snp.trailing).offset(3)
            make.trailing.equalTo(snp.trailing)
            make.centerY.equalTo(snsIcon.snp.centerY)
        }

        introductionLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(snsIcon.snp.bottom).offset(10)
            make.width.equalTo(210)
        }

        divderView.snp.makeConstraints { make in
            make.top.equalTo(introductionLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(snp.horizontalEdges)
            make.height.equalTo(1)
        }

        townsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(divderView).offset(18)
            make.leading.equalTo(snp.leading)
        }

        townsContentLabel.snp.makeConstraints { make in
            make.leading.equalTo(townsTitleLabel.snp.trailing).offset(16)
            make.centerY.equalTo(townsTitleLabel)
        }

        townsExtendImage.snp.makeConstraints { make in
            make.leading.equalTo(townsContentLabel.snp.trailing).offset(6)
            make.centerY.equalTo(townsContentLabel.snp.centerY)
            make.width.equalTo(4)
        }

        keywordTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(townsTitleLabel.snp.bottom).offset(9)
            make.leading.equalTo(snp.leading)
        }

        keywordContentLabel.snp.makeConstraints { make in
            make.leading.equalTo(keywordTitleLabel.snp.trailing).offset(16)
            make.centerY.equalTo(keywordTitleLabel)
            make.bottom.equalTo(snp.bottom).offset(-18)
        }

        introductionLabel.isUserInteractionEnabled = true
        let introductionTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleIntroductionTap))
        introductionLabel.addGestureRecognizer(introductionTapGestureRecognizer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(photographer: PhotographerDetail) {
        followersCountLabel.text = String(photographer.followers)
        profileImage.image = photographer.image ?? UIImage(named: "ProfileImagePlaceholder")
        nameLabel.text = "\(photographer.name) 작가"
        self.introductionLabel.setText(photographer.introduction)
        self.snsIcon.image = getIconBySocialType(photographer.socialType)

        let snsIdAttributedString = NSAttributedString(
            string: photographer.socialId,
            attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]
        )
        self.snsIdLabel.attributedText = snsIdAttributedString

        townsContentLabel.text = getTownsLabelText(photographer.towns)
        keywordContentLabel.text = photographer.tags.joined(separator: ", ")

        if photographer.isAbleToDirectShoot {
            directShootBadge.isHidden = false
        } else {
            directShootBadge.isHidden = true
        }
    }

    private func getIconBySocialType(_ socialType: PhotographerDetail.SocialType) -> UIImage? {
        switch socialType {
        case .instagram:
            return UIImage(named: "InstagramIcon")
        }
    }

    private func getTownsLabelText(_ towns: [String]) -> String {
        let maxCount = 2

        if towns.count <= maxCount {
            return towns.joined(separator: ", ")
        }

        let remained = towns.count - 2
        var result = ""
        towns.enumerated().forEach { index, town in
            if index < maxCount {
                if index == maxCount - 1 {
                    result += town
                } else {
                    result += "\(town), "
                }
            }
        }

        return "\(result) 외 \(remained)개"
    }

    @objc private func handleIntroductionTap() {
        introductionLabel.numberOfLines = 0
    }
}
