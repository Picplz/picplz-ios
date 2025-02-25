//
//  SignUpViewController.swift
//  PicplzClient
//
//  Created by 임영택 on 2/15/25.
//

import UIKit
import Combine
import OSLog

final class SignUpNicknamePageViewController: UIViewController {
    var viewModel: SignUpNicknamePageViewModelProtocol!
    private var subscriptions: Set<AnyCancellable> = []
    
    private let contentView = SignUpNicknameSettingView()
    private let nextButton = UIPickplzButton()
    private var nextButtonBottomConstraint: NSLayoutConstraint?
    
    private var log = Logger.of("SignUpNicknamePageViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "닉네임 설정하기"
        
        setup()
        bind()
        registerKeyboardObserver()
        
        // hide keyboard when view tapped
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardWhenTapped))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeKeyboardObserver()
    }
    
    private func setup() {
        view.backgroundColor = .picplzWhite
        
        // MARK: ContentView
        contentView.nicknameDidUpdatedHandler = { [weak self] (_ value: String) in
            self?.viewModel?.nicknameDidSet(nickname: value)
        }
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15.0),
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 15.0),
        ])
        
        // MARK: Next Button
        nextButton.setTitle("다음", for: .normal)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        view.addSubview(nextButton)
        
        nextButtonBottomConstraint = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 47)
        NSLayoutConstraint.activate([
            nextButton.heightAnchor.constraint(equalToConstant: 60),
            nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            view.rightAnchor.constraint(equalTo: nextButton.rightAnchor, constant: 15),
            nextButtonBottomConstraint!,
        ])
    }

    private func bind() {
        viewModel.nextButtonEnabledPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] nextButtonEnabled in
                if nextButtonEnabled {
                    self?.nextButton.backgroundColor = .picplzBlack
                    self?.nextButton.isEnabled = true
                } else {
                    self?.nextButton.backgroundColor = .grey3
                    self?.nextButton.isEnabled = false
                }
            }
            .store(in: &subscriptions)
        
        viewModel.nicknameCheckResultPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                switch result {
                case .valid:
                    self?.contentView.errorMessageLabel.text = " "
                case .duplicated:
                    self?.contentView.errorMessageLabel.text = "중복된 닉네임입니다."
                case .invalidFormat:
                    self?.contentView.errorMessageLabel.text = "닉네임을 다시 입력해주세요."
                }
            }
            .store(in: &subscriptions)
    }
    
    @objc private func hideKeyboardWhenTapped() {
        view.endEditing(true)
    }
    
    private func registerKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustViewHeight(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustViewHeight(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func adjustViewHeight(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardInfo.cgRectValue
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            nextButtonBottomConstraint?.constant = adjustmentHeight
        } else {
            nextButtonBottomConstraint?.constant = 47
        }
    }
    
    @objc private func nextButtonTapped() {
        viewModel.nextButtonDidTapped()
    }
}
