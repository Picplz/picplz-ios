//
//  SignUpProfileImageSettingView.swift
//  PicplzClient
//
//  Created by 임영택 on 2/15/25.
//

import UIKit

final class SignUpMemberTypeSettingView: UIView {
    let titleLabel = UILabel()
    let photographerTypeLabel = UILabel()
    let customerTypeLabel = UILabel()
    let photographerSelectorView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MemberTypePhotographer")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    let customerSelectorView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MemberTypeCustomer")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    var selectedMemberType: SignUpSession.MemberType? {
        didSet {
            guard let selectedMemberType = selectedMemberType else {
                return
            }

            adjustViewWithSelectedMemberType(for: selectedMemberType)
        }
    }

    private lazy var photographerSelectorViewHeightConstrint = photographerSelectorView
        .heightAnchor.constraint(equalToConstant: 120.0)
    private lazy var photographerSelectorViewWidthConstrint = photographerSelectorView
        .widthAnchor.constraint(equalToConstant: 120.0)

    private lazy var customerSelectorViewHeightConstrint = customerSelectorView
        .heightAnchor.constraint(equalToConstant: 120.0)
    private lazy var customerSelectorViewWidthConstrint = customerSelectorView
        .widthAnchor.constraint(equalToConstant: 120.0)

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
        titleLabel.numberOfLines = 2

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .center

        let attributedString = NSMutableAttributedString(string: "가입하실 회원 타입을\n선택해주세요.")
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )

        titleLabel.attributedText = attributedString

        photographerSelectorView.translatesAutoresizingMaskIntoConstraints = false

        customerSelectorView.translatesAutoresizingMaskIntoConstraints = false

        photographerTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        photographerTypeLabel.text = "찍사"
        photographerTypeLabel.font = .buttonTitle
        photographerTypeLabel.textAlignment = .center

        customerTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        customerTypeLabel.text = "고객"
        customerTypeLabel.font = .buttonTitle
        customerTypeLabel.textAlignment = .center
    }

    private func layout() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 80.0), // top padding
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ])

        addSubview(photographerSelectorView)
        NSLayoutConstraint.activate([
            photographerSelectorView.topAnchor.constraint(lessThanOrEqualTo: titleLabel.bottomAnchor, constant: 78.0),
            photographerSelectorView.leftAnchor.constraint(equalTo: leftAnchor, constant: 30.0),
            photographerSelectorViewWidthConstrint,
            photographerSelectorViewHeightConstrint
        ])

        addSubview(customerSelectorView)
        NSLayoutConstraint.activate([
            customerSelectorView.topAnchor.constraint(lessThanOrEqualTo: titleLabel.bottomAnchor, constant: 78.0),
            rightAnchor.constraint(equalTo: customerSelectorView.rightAnchor, constant: 30.0),
            customerSelectorViewWidthConstrint,
            customerSelectorViewHeightConstrint,
            customerSelectorView.bottomAnchor.constraint(equalTo: photographerSelectorView.bottomAnchor)
        ])

        addSubview(photographerTypeLabel)
        NSLayoutConstraint.activate([
            photographerTypeLabel.topAnchor.constraint(equalTo: photographerSelectorView.bottomAnchor, constant: 10.0),
            photographerTypeLabel.centerXAnchor.constraint(equalTo: photographerSelectorView.centerXAnchor)
        ])

        addSubview(customerTypeLabel)
        NSLayoutConstraint.activate([
            customerTypeLabel.topAnchor.constraint(equalTo: customerSelectorView.bottomAnchor, constant: 10.0),
            customerTypeLabel.centerXAnchor.constraint(equalTo: customerSelectorView.centerXAnchor)
        ])
    }

    private func adjustViewWithSelectedMemberType(for memberType: SignUpSession.MemberType) {
        if selectedMemberType == .customer {
            UIView.animate(withDuration: 0.3) {
                self.photographerSelectorViewWidthConstrint.constant = 120.0
                self.photographerSelectorViewHeightConstrint.constant = 120.0

                self.customerSelectorViewWidthConstrint.constant = 160.0
                self.customerSelectorViewHeightConstrint.constant = 160.0

                self.layoutIfNeeded()
            }
        }

        if selectedMemberType == .photographer {
            UIView.animate(withDuration: 0.3) {
                self.photographerSelectorViewWidthConstrint.constant = 160.0
                self.photographerSelectorViewHeightConstrint.constant = 160.0

                self.customerSelectorViewWidthConstrint.constant = 120.0
                self.customerSelectorViewHeightConstrint.constant = 120.0

                self.layoutIfNeeded()
            }
        }
    }
}
