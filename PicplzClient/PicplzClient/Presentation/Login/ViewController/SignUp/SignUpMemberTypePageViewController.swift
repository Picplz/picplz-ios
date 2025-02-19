//
//  SignUpProfileImageSettingViewController.swift
//  PicplzClient
//
//  Created by 임영택 on 2/18/25.
//

import Foundation

import UIKit
import Combine
import OSLog

final class SignUpMemberTypePageViewController: UIViewController {
//    var viewModel: SignUpMemberTypePageViewModelProtocol!
    private var subscriptions: Set<AnyCancellable> = []
    
    private let contentView = SignUpMemberTypeSettingView()
    private let nextButton = UIButton()
    
    private var log = Logger.of("SignUpMemberTypePageViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "회원 타입 선택"
        
        setup()
        bind()
    }
    
    private func setup() {
        view.backgroundColor = .picplzWhite
        
        // MARK: ContentView
        contentView.isUserInteractionEnabled = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15.0),
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 15.0),
            contentView.heightAnchor.constraint(equalToConstant: 450),
        ])
        
        let photographerSelectorTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didMemberTypeSelected(_:)))
        contentView.photographerSelectorView.addGestureRecognizer(photographerSelectorTapGestureRecognizer)
        
        let customerSelectorTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didMemberTypeSelected(_:)))
        contentView.customerSelectorView.addGestureRecognizer(customerSelectorTapGestureRecognizer)
        
        // MARK: Next Button
        // FIXME: Duplicated
        nextButton.setTitle("다음", for: .normal)
        nextButton.setTitleColor(.grey2, for: .normal)
        nextButton.titleLabel?.font = .buttonTitle
        nextButton.backgroundColor = .grey3
        nextButton.layer.cornerRadius = 5.0
        nextButton.clipsToBounds = true
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            nextButton.heightAnchor.constraint(equalToConstant: 60),
            nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            view.rightAnchor.constraint(equalTo: nextButton.rightAnchor, constant: 15),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 47),
        ])
    }
    
    private func bind() {
    }
    
    @objc private func nextButtonTapped() {
//        viewModel.nextButtonDidTapped()
    }
    
    @objc private func didMemberTypeSelected(_ sender: UITapGestureRecognizer) {
        if sender.view === contentView.customerSelectorView {
            contentView.selectedMemberType = .customer
        } else if sender.view === contentView.photographerSelectorView {
            contentView.selectedMemberType = .photographer
        }
    }
}
