//
//  SignUpPhotographerCareerTypeSettingView.swift
//  PicplzClient
//
//  Created by 임영택 on 2/20/25.
//

import UIKit

final class SignUpPhotographerCareerTypeSettingView: UIView {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let majorButton = CareerTypeButton()
    let jobButton = CareerTypeButton()
    let influencerButton = CareerTypeButton()
    
    private lazy var careerTypeAndButtonMapping: [SignUpSession.CareerType: UIButton] = [
        .major: majorButton,
        .job: jobButton,
        .influencer: influencerButton,
    ]
    
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
        titleLabel.text = "해당되는 경험을 골라주세요."
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = .body
        subtitleLabel.textColor = .picplzBlack
        subtitleLabel.text = "여기 라이팅 바꿔야할거같은데 우리이거 수정하기로햇던듯?"
        
        majorButton.translatesAutoresizingMaskIntoConstraints = false
        majorButton.setTitle("사진 전공", for: .normal)
        
        jobButton.translatesAutoresizingMaskIntoConstraints = false
        jobButton.setTitle("수익 창출", for: .normal)
        
        influencerButton.translatesAutoresizingMaskIntoConstraints = false
        influencerButton.setTitle("SNS 계정 운영", for: .normal)
    }
    
    private func layout() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 74.0), // top padding
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
        ])
        
        addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6.0),
            subtitleLabel.leftAnchor.constraint(equalTo: leftAnchor),
        ])
        
        addSubview(majorButton)
        NSLayoutConstraint.activate([
            majorButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 50.0),
            majorButton.leftAnchor.constraint(equalTo: leftAnchor),
            majorButton.heightAnchor.constraint(equalToConstant: 40.0),
        ])
        
        addSubview(jobButton)
        NSLayoutConstraint.activate([
            jobButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 50.0),
            jobButton.leftAnchor.constraint(equalTo: majorButton.rightAnchor, constant: 6.0),
            jobButton.heightAnchor.constraint(equalToConstant: 40.0),
        ])
        
        addSubview(influencerButton)
        NSLayoutConstraint.activate([
            influencerButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 50.0),
            influencerButton.leftAnchor.constraint(equalTo: jobButton.rightAnchor, constant: 6.0),
            influencerButton.heightAnchor.constraint(equalToConstant: 40.0),
        ])
    }
    
    func selectCareerType(for selectedCareerType: SignUpSession.CareerType) {
        careerTypeAndButtonMapping.forEach { (careerType, button) in
            let isSelected: Bool = careerType == selectedCareerType
            button.isSelected = isSelected
        }
    }
}

final class CareerTypeButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configuration = UIButton.Configuration.plain()
        self.configuration?.contentInsets = .init(top: 0, leading: 11.5, bottom: 0, trailing: 11.5)
        self.titleLabel?.font = UIFont(name: FontFamily.pretendardRegular.rawValue, size: 14)!
        self.backgroundColor = .picplzWhite
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        self.adjustStyleForIsSelectedStatus()
    }
    
    override var isSelected: Bool {
        didSet {
            adjustStyleForIsSelectedStatus()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        setTitleColor(.grey4, for: state)
    }
    
    func adjustStyleForIsSelectedStatus() {
        if isSelected {
            UIView.animate(withDuration: 0.1) {
                self.setTitleColor(.picplzBlack, for: .normal)
                self.titleLabel?.font = UIFont(name: FontFamily.pretendardBold.rawValue, size: 14)!
                self.layer.borderColor = UIColor.picplzBlack.cgColor
                self.layer.borderWidth = 1.0
            }
        } else {
            UIView.animate(withDuration: 0.1) {
                self.setTitleColor(.grey4, for: .normal)
                self.titleLabel?.font = UIFont(name: FontFamily.pretendardRegular.rawValue, size: 14)!
                self.layer.borderColor = UIColor.grey3.cgColor
                self.layer.borderWidth = 1.0
            }
        }
    }
}
