//
//  SignUpProfileImageSettingViewController.swift
//  PicplzClient
//
//  Created by 임영택 on 2/24/25.
//

import Foundation

import UIKit
import Combine
import OSLog

final class SignUpPhotographerCareerPeriodViewController: UIViewController {
//    var viewModel: SignUpPhotographerCareerPeriodViewModelProtocol!
    private var subscriptions: Set<AnyCancellable> = []
    
    private let contentView = SignUpPhotographerCareerPeriodSettingView()
    private let nextButton = UIPickplzButton()
    
    private let yearsTitles: [String] = (0...30).map { "\($0)년" }
    private let monthsTitles: [String] = (0...12).map { "\($0)개월" }
    
    private var log = Logger.of("SignUpPhotographerCareerPeriodViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "경력 선택"
        
        setup()
        bind()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didEditingEnd))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setup() {
        view.backgroundColor = .picplzWhite
        
        // MARK: ContentView
        configureToolbar(for: contentView.yearsToolbar)
        configureToolbar(for: contentView.monthsToolbar)
        
        contentView.yearsPickerView.delegate = self
        contentView.yearsPickerView.dataSource = self
        contentView.monthsPickerView.delegate = self
        contentView.monthsPickerView.dataSource = self
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15.0),
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 15.0),
            contentView.heightAnchor.constraint(equalToConstant: 450),
        ])
        
        // MARK: Next Button
        nextButton.setTitle("다음", for: .normal)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(didNextButtonTapped), for: .touchUpInside)
        nextButton.isEnabled = false
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            nextButton.heightAnchor.constraint(equalToConstant: 60),
            nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            view.rightAnchor.constraint(equalTo: nextButton.rightAnchor, constant: 15),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 47),
        ])
    }
    
    func bind() {
        
    }
    
    private func configureToolbar(for toolbar: UIToolbar) {
        let spacer = UIBarButtonItem.flexibleSpace()
        let doneItem = UIBarButtonItem(title: "선택", image: nil, target: self, action: #selector(didEditingEnd))
        toolbar.setItems([spacer, doneItem], animated: true)
    }
    
    @objc private func didNextButtonTapped() {
//        viewModel.nextButtonDidTapped()
    }
    
    @objc private func didEditingEnd() {
        view.endEditing(true)
    }
}

extension SignUpPhotographerCareerPeriodViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView === contentView.yearsPickerView {
            // FIXME: viewModel 연동
            contentView.yearsTextField.text = String(row)
        }
        
        if pickerView === contentView.monthsPickerView {
            // FIXME: viewModel 연동
            contentView.monthsTextField.text = String(row)
        }
    }
}

extension SignUpPhotographerCareerPeriodViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView === contentView.yearsPickerView {
            return yearsTitles.count
        }
        
        if pickerView === contentView.monthsPickerView {
            return monthsTitles.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView === contentView.yearsPickerView {
            return yearsTitles[row]
        }
        
        if pickerView === contentView.monthsPickerView {
            return monthsTitles[row]
        }
        
        return nil
    }
}
