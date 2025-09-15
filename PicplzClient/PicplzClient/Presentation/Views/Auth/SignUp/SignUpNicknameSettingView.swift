//
//  SignUpNicknameSettingView.swift
//  PicplzClient
//
//  Created by 임영택 on 2/15/25.
//

import UIKit

final class SignUpNicknameSettingView: UIView {
    let titleLabel = UILabel()
    let nicknameTextField = UITextField()
    let errorMessageLabel = UILabel()
    let informationLabel = UILabel()
    var nicknameDidUpdatedHandler = { (_ value: String) in }

    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()

        nicknameTextField.addTarget(self, action: #selector(didTextFieldEditingChanged(_:)), for: .editingChanged)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func style() {
        self.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .title
        titleLabel.text = "닉네임을 입력해주세요"
        titleLabel.textColor = .black

        nicknameTextField.translatesAutoresizingMaskIntoConstraints = false
        nicknameTextField.attributedPlaceholder = NSAttributedString(
            string: "닉네임 입력",
            attributes: [
                NSAttributedString.Key.font: UIFont.largeBody,
                NSAttributedString.Key.foregroundColor: UIColor.ppGrey3
            ]
        )
        nicknameTextField.textColor = .ppBlack
        nicknameTextField.font = .largeBody
        nicknameTextField.backgroundColor = .ppGrey1
        nicknameTextField.layer.cornerRadius = 5.0
        nicknameTextField.layer.borderWidth = 1.0
        nicknameTextField.layer.borderColor = UIColor.ppGrey2.cgColor
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: 50))
        nicknameTextField.leftView = paddingView
        nicknameTextField.leftViewMode = .always
        nicknameTextField.rightView = paddingView
        nicknameTextField.rightViewMode = .always

        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.text = "* 에러메시지"
        errorMessageLabel.textColor = .red
        errorMessageLabel.font = .caption

        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        informationLabel.numberOfLines = 4
        informationLabel.text = "· 한글, 영문, 숫자 입력 가능 (2~15자)\n"
                                + "· 중복 닉네임은 불가\n"
                                + "· 이모티콘, 특수문자 사용 불가\n"
                                + "· 닉네임의 처음과 마지막 부분 공백 사용 불가"
        informationLabel.font = .caption
        informationLabel.textColor = .ppGrey3
    }

    private func layout() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 160.0), // top padding
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ])

        addSubview(nicknameTextField)
        NSLayoutConstraint.activate([
            nicknameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.0),
            nicknameTextField.leftAnchor.constraint(equalTo: leftAnchor),
            nicknameTextField.rightAnchor.constraint(equalTo: rightAnchor),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])

        addSubview(errorMessageLabel)
        NSLayoutConstraint.activate([
            errorMessageLabel.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 3.0),
            errorMessageLabel.leftAnchor.constraint(equalTo: leftAnchor),
            errorMessageLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ])

        addSubview(informationLabel)
        NSLayoutConstraint.activate([
            informationLabel.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 5.0),
            informationLabel.leftAnchor.constraint(equalTo: leftAnchor),
            informationLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 400)
    }

    @objc private func didTextFieldEditingChanged(_ textField: UITextField) {
        self.nicknameDidUpdatedHandler(textField.text ?? "")
    }
}
