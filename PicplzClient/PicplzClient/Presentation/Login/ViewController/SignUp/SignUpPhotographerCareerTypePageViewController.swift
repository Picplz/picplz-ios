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

final class SignUpPhotographerCareerTypePageViewController: UIViewController {
    var viewModel: SignUpPhotographerCareerTypePageViewModelProtocol!
    private var subscriptions: Set<AnyCancellable> = []
    
    private let promptContentView = SignUpPhotographerCareerExistsPromptView()
    private let settingContentView = SignUpPhotographerCareerTypeSettingView()
    private let alertView = UIPickplzAlert()
    private let nextButton = UIPickplzButton()
    
    private var log = Logger.of("SignUpPhotographerCareerTypePageViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "경력 선택"
        
        setup()
        bind()
    }
    
    private func setup() {
        view.backgroundColor = .picplzWhite
        
        // MARK: ContentView - Prompting View
        promptContentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(promptContentView)
        
        NSLayoutConstraint.activate([
            promptContentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            promptContentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15.0),
            view.rightAnchor.constraint(equalTo: promptContentView.rightAnchor, constant: 15.0),
            promptContentView.heightAnchor.constraint(equalToConstant: 450),
        ])
        
        promptContentView.informationButton.addTarget(self, action: #selector(didInformationButtonTapped), for: .touchUpInside)
        promptContentView.yesButton.addTarget(self, action: #selector(didYesButtonTapped), for: .touchUpInside)
        promptContentView.noButton.addTarget(self, action: #selector(didNoButtonTapped), for: .touchUpInside)
        
        // MARK: ContentView - Setting View
        settingContentView.translatesAutoresizingMaskIntoConstraints = false
        settingContentView.isHidden = true
        view.addSubview(settingContentView)
        
        NSLayoutConstraint.activate([
            settingContentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingContentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15.0),
            view.rightAnchor.constraint(equalTo: settingContentView.rightAnchor, constant: 15.0),
            settingContentView.heightAnchor.constraint(equalToConstant: 450),
        ])
        
        settingContentView.majorButton.addTarget(self, action: #selector(didMajorSelected), for: .touchUpInside)
        settingContentView.jobButton.addTarget(self, action: #selector(didJobSelected), for: .touchUpInside)
        settingContentView.influencerButton.addTarget(self, action: #selector(didInfluencerSelected), for: .touchUpInside)
        
        // MARK: Information Alert
        alertView.title = "사진 촬영 경험이란?"
        
        let alertTextOriginal = "사진 전공 / 사진으로 수익 창출 / 사진 SNS계정 운영 등의 경험이 있는 경우를 말해요."
        let captionBoldFont = UIFont(name: FontFamily.pretendardBold.rawValue, size: 12)!
        if let range = alertTextOriginal.range(of: "사진 전공 / 사진으로 수익 창출 / 사진 SNS계정 운영") {
            let alertAttributedString = NSMutableAttributedString(string: alertTextOriginal)
            alertAttributedString.addAttribute(.font, value: captionBoldFont, range: NSRange(range, in: alertTextOriginal))
            alertView.contentText = alertAttributedString
        }
        
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.isHidden = true
        view.addSubview(alertView)
        NSLayoutConstraint.activate([
            alertView.topAnchor.constraint(equalTo: view.topAnchor),
            alertView.leftAnchor.constraint(equalTo: view.leftAnchor),
            alertView.rightAnchor.constraint(equalTo: view.rightAnchor),
            alertView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        // MARK: Next Button
        nextButton.setTitle("다음", for: .normal)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(didNextButtonTapped), for: .touchUpInside)
        nextButton.isEnabled = false
        nextButton.isHidden = true
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            nextButton.heightAnchor.constraint(equalToConstant: 60),
            nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            view.rightAnchor.constraint(equalTo: nextButton.rightAnchor, constant: 15),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 47),
        ])
    }
    
    func bind() {
        viewModel.shouldShowPromptPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] shouldShowPrompt in
                if shouldShowPrompt {
                    self?.promptContentView.isHidden = false
                    self?.settingContentView.isHidden = true
                    self?.nextButton.isHidden = true
                } else {
                    self?.promptContentView.isHidden = true
                    self?.settingContentView.isHidden = false
                    self?.nextButton.isHidden = false
                }
            }
            .store(in: &subscriptions)
        
        viewModel.selectedCareerTypePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] careerType in
                self?.settingContentView.selectCareerType(for: careerType)
                self?.nextButton.isEnabled = true
            }
            .store(in: &subscriptions)
    }
    
    @objc private func didYesButtonTapped() {
        viewModel.careerYesButtonTapped()
    }
    
    @objc private func didNoButtonTapped() {
        viewModel.careerNoButtonTapped()
    }
    
    @objc private func didMajorSelected() {
        viewModel.careerTypeSelected(for: .major)
    }
    
    @objc private func didJobSelected() {
        viewModel.careerTypeSelected(for: .job)
    }
    
    @objc private func didInfluencerSelected() {
        viewModel.careerTypeSelected(for: .influencer)
    }
    
    @objc private func didInformationButtonTapped() {
        alertView.open()
    }
    
    @objc private func didNextButtonTapped() {
        viewModel.nextButtonDidTapped()
    }
}
