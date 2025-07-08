//
//  SignUpPhotographerCareerExistsPromptView.swift
//  PicplzClient
//
//  Created by 임영택 on 2/15/25.
//

import UIKit

final class SignUpPhotographerCareerExistsPromptView: UIView {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let informationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "InformationIcon"), for: .normal)
        return button
    }()
    let yesButton = selectablePicPlzButton()
    let noButton = selectablePicPlzButton()
    let buttonsHolderView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 11.0
        stackView.distribution = .fillEqually
        return stackView
    }()
    
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
        titleLabel.text = "사진 촬영 경험이 있으신가요?"
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = .body
        subtitleLabel.textColor = .ppBlack
        subtitleLabel.text = "픽플즈는 사진 경력이 없는 금손님도 환영해요!"
        
        informationButton.translatesAutoresizingMaskIntoConstraints = false
        
        yesButton.setTitle("있어요", for: .normal)
        yesButton.isSelected = false
        buttonsHolderView.addArrangedSubview(yesButton)
        noButton.setTitle("없어요", for: .normal)
        noButton.isSelected = false
        buttonsHolderView.translatesAutoresizingMaskIntoConstraints = false
        buttonsHolderView.addArrangedSubview(noButton)
    }
    
    private func layout() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 74.0), // top padding
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
        ])
        
        addSubview(informationButton)
        NSLayoutConstraint.activate([
            informationButton.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 4.0),
            informationButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            informationButton.widthAnchor.constraint(equalToConstant: 16),
            informationButton.heightAnchor.constraint(equalToConstant: 17),
        ])
        
        addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6.0),
            subtitleLabel.leftAnchor.constraint(equalTo: leftAnchor),
        ])
        
        addSubview(buttonsHolderView)
        NSLayoutConstraint.activate([
            buttonsHolderView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 50.0),
            buttonsHolderView.leftAnchor.constraint(equalTo: leftAnchor),
            buttonsHolderView.rightAnchor.constraint(equalTo: rightAnchor),
            buttonsHolderView.heightAnchor.constraint(equalToConstant: 65.0),
        ])
    }
}

final class selectablePicPlzButton: UIPicplzButton {
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = .black
                self.layer.borderColor = .none
                self.layer.borderWidth = .zero
                self.setTitleColor(.ppWhite, for: .normal)
            } else {
                self.backgroundColor = .white
                self.layer.borderColor = UIColor.ppGrey3.cgColor
                self.layer.borderWidth = 1.0
                self.setTitleColor(.ppBlack, for: .normal)
            }
        }
    }
}
