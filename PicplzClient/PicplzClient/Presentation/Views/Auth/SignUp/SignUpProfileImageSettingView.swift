//
//  SignUpProfileImageSettingView.swift
//  PicplzClient
//
//  Created by 임영택 on 2/15/25.
//

import UIKit

final class SignUpProfileImageSettingView: UIView {
    let titleLabel = UILabel()
    let profileImageButton = UIButton()
    let cameraButton = UIButton()
    let informationLabel = UILabel()

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
        self.isUserInteractionEnabled = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .title
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        profileImageButton.setImage(UIImage(named: "ProfileImagePlaceholder"), for: .normal)
        profileImageButton.layer.cornerRadius = 80.0 // perfect circle
        profileImageButton.clipsToBounds = true

        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.setImage(UIImage(named: "CameraIcon"), for: .normal)
        cameraButton.layer.cornerRadius = 16.5
        cameraButton.clipsToBounds = true

        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        informationLabel.font = .title
        informationLabel.numberOfLines = 2
        informationLabel.textColor = .black
        informationLabel.textAlignment = .center
        setInformationLabelText("프로필 이미지를\n설정해 주세요.")
    }

    private func layout() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 80.0), // top padding
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ])

        addSubview(profileImageButton)
        NSLayoutConstraint.activate([
            profileImageButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 26.0),
            profileImageButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageButton.widthAnchor.constraint(equalToConstant: 160.0),
            profileImageButton.heightAnchor.constraint(equalToConstant: 160.0)
        ])

        addSubview(cameraButton)
        NSLayoutConstraint.activate([
            cameraButton.widthAnchor.constraint(equalToConstant: 33.0),
            cameraButton.heightAnchor.constraint(equalToConstant: 33.0),
            profileImageButton.rightAnchor.constraint(equalTo: cameraButton.rightAnchor, constant: 5.0),
            profileImageButton.bottomAnchor.constraint(equalTo: cameraButton.bottomAnchor, constant: 5.0)
        ])

        addSubview(informationLabel)
        NSLayoutConstraint.activate([
            informationLabel.topAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: 75.0),
            informationLabel.leftAnchor.constraint(equalTo: leftAnchor),
            informationLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }

    func setUserNickname(for nickname: String) {
        titleLabel.text = "안녕하세요 \(nickname)님!"
    }

    func setInformationLabelText(_ text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .center

        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))

        informationLabel.attributedText = attributedString
    }
}
