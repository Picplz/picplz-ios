//
//  SignUpViewController.swift
//  PicplzClient
//
//  Created by 임영택 on 2/15/25.
//

import UIKit
import OSLog

final class SignUpViewController: UIViewController {
    private let contentView = SignUpCommonNicknameFormView()
    private let nextButton = UIButton()
    private var nextButtonBottomConstraint: NSLayoutConstraint?
    
    private var log = Logger.of("LoginViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "닉네임 설정하기"
        
        setup()
        registerKeyboardObserver()
        
        // hide keyboard when view tapped
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardWhenTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeKeyboardObserver()
    }
    
    private func setup() {
        view.backgroundColor = .picplzWhite
        
        // MARK: ContentView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15.0),
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 15.0),
        ])
        
        // MARK: Next Button
        nextButton.setTitle("다음", for: .normal)
        nextButton.setTitleColor(.grey2, for: .normal)
        nextButton.backgroundColor = .grey3
        nextButton.layer.cornerRadius = 5.0
        nextButton.clipsToBounds = true
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)
        
        nextButtonBottomConstraint = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 47)
        NSLayoutConstraint.activate([
            nextButton.heightAnchor.constraint(equalToConstant: 60),
            nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            view.rightAnchor.constraint(equalTo: nextButton.rightAnchor, constant: 15),
            nextButtonBottomConstraint!,
        ])
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
}
