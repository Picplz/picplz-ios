//
//  SignUpFinishVIewController.swift
//  PicplzClient
//
//  Created by 임영택 on 2/25/25.
//

import UIKit
import OSLog

protocol SignUpFinishViewControllerDelegate: AnyObject {
    func didTapFinishButton()
}

final class SignUpFinishViewController: UIViewController {
    var delegate: SignUpFinishViewControllerDelegate?
    var profileImagePath: URL? {
        didSet {
            if let profileImagePath = profileImagePath {
                profileImageView.image = UIImage(contentsOfFile: profileImagePath.path)
            } else {
                profileImageView.image = UIImage(named: "ProfileImagePlaceholder")
            }
        }
    }
    var nickname: String? {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            paragraphStyle.alignment = .center

            let attributedString = NSMutableAttributedString(string: "\(nickname ?? "")님,\n가입이 완료되었습니다!")
            let wholeRange = NSRange(location: 0, length: attributedString.length)
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: wholeRange)
            attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: wholeRange)
            attributedString.addAttribute(.font, value: UIFont.bigTitle, range: wholeRange)

            titleLabel.attributedText = attributedString

            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }

    private let backgroundView = SignUpFinishBackgroundVIew()
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 97
        imageView.clipsToBounds = true
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    private let subtitleLable: UILabel = {
        let label = UILabel()
        label.font = .body
        label.textColor = .black
        label.text = "픽플즈와 인생샷을 건져보세요."
        label.textAlignment = .center
        return label
    }()
    private let startButton = UIPicplzButton()

    private var log = Logger.of("SignUpFinishViewController")

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "프로필 설정 완료"

        setup()
    }

    private func setup() {
        view.backgroundColor = .ppWhite

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLable.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0),
            backgroundView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        view.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 84.0),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 194.0),
            profileImageView.heightAnchor.constraint(equalToConstant: 194.0)
        ])

        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40.0),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        view.addSubview(subtitleLable)
        NSLayoutConstraint.activate([
            subtitleLable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.0),
            subtitleLable.leftAnchor.constraint(equalTo: view.leftAnchor),
            subtitleLable.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        // MARK: Next Button
        startButton.setTitle("픽플즈 시작하기", for: .normal)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        view.addSubview(startButton)

        NSLayoutConstraint.activate([
            startButton.heightAnchor.constraint(equalToConstant: 60),
            startButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            view.rightAnchor.constraint(equalTo: startButton.rightAnchor, constant: 15),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 47)
        ])
    }

    @objc private func startButtonTapped() {
        delegate?.didTapFinishButton()
    }
}
