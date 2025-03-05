//
//  SignUpPhotographerCareerPeriodSettingView.swift
//  PicplzClient
//
//  Created by 임영택 on 2/24/25.
//

import UIKit

final class SignUpPhotographerCareerPeriodSettingView: UIView {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    let yearsTextField = UITextField()
    let yearsCaptionLabel = UILabel()
    let monthsTextField = UITextField()
    let monthsCaptionLabel = UILabel()
    
    let yearsToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 40.0))
    let yearsPickerView = UIPickerView()
    
    let monthsToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 40.0))
    let monthsPickerView = UIPickerView()
    
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
        titleLabel.text = "경력 기간을 입력해주세요."
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = .body
        subtitleLabel.textColor = .picplzBlack
        subtitleLabel.text = "1년 미만일 경우 0년 n개월로 입력해주세요."
        
        yearsTextField.translatesAutoresizingMaskIntoConstraints = false
        yearsTextField.text = "0"
        yearsTextField.font = .title
        yearsTextField.textAlignment = .center
        yearsTextField.textColor = .grey3
        yearsTextField.layer.borderColor = UIColor.black.cgColor
        yearsTextField.layer.borderWidth = 1.0
        yearsTextField.layer.cornerRadius = 5.0
        yearsTextField.clipsToBounds = true
        yearsTextField.inputView = yearsPickerView
        yearsTextField.inputAccessoryView = yearsToolbar
        yearsTextField.tintColor = .clear // hide cursor
        yearsTextField.delegate = self
        
        yearsCaptionLabel.translatesAutoresizingMaskIntoConstraints = false
        yearsCaptionLabel.text = "년"
        yearsCaptionLabel.font = .title
        yearsCaptionLabel.textColor = .black
        
        monthsTextField.translatesAutoresizingMaskIntoConstraints = false
        monthsTextField.text = "0"
        monthsTextField.font = .title
        monthsTextField.textAlignment = .center
        monthsTextField.textColor = .grey3
        monthsTextField.layer.borderColor = UIColor.black.cgColor
        monthsTextField.layer.borderWidth = 1.0
        monthsTextField.layer.cornerRadius = 5.0
        monthsTextField.clipsToBounds = true
        monthsTextField.inputView = monthsPickerView
        monthsTextField.inputAccessoryView = monthsToolbar
        monthsTextField.tintColor = .clear // hide cursor
        monthsTextField.delegate = self
        
        monthsCaptionLabel.translatesAutoresizingMaskIntoConstraints = false
        monthsCaptionLabel.text = "개월"
        monthsCaptionLabel.font = .title
        monthsCaptionLabel.textColor = .black
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
        
        addSubview(yearsTextField)
        NSLayoutConstraint.activate([
            yearsTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 50.0),
            yearsTextField.leftAnchor.constraint(equalTo: leftAnchor),
            yearsTextField.widthAnchor.constraint(equalToConstant: 84.0),
            yearsTextField.heightAnchor.constraint(equalToConstant: 39.0),
        ])
        
        addSubview(yearsCaptionLabel)
        NSLayoutConstraint.activate([
            yearsCaptionLabel.bottomAnchor.constraint(equalTo: yearsTextField.bottomAnchor),
            yearsCaptionLabel.leftAnchor.constraint(equalTo: yearsTextField.rightAnchor, constant: 6.0),
        ])
        
        addSubview(monthsTextField)
        NSLayoutConstraint.activate([
            monthsTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 50.0),
            monthsTextField.leftAnchor.constraint(equalTo: yearsCaptionLabel.rightAnchor, constant: 20.0),
            monthsTextField.widthAnchor.constraint(equalToConstant: 84.0),
            monthsTextField.heightAnchor.constraint(equalToConstant: 39.0),
        ])
        
        addSubview(monthsCaptionLabel)
        NSLayoutConstraint.activate([
            monthsCaptionLabel.bottomAnchor.constraint(equalTo: monthsTextField.bottomAnchor),
            monthsCaptionLabel.leftAnchor.constraint(equalTo: monthsTextField.rightAnchor, constant: 6.0),
        ])
    }
}

extension SignUpPhotographerCareerPeriodSettingView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
