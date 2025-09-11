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

final class SignUpProfileImagePageViewController: UIViewController {
    var viewModel: SignUpProfileImagePageViewModelProtocol!
    private var subscriptions: Set<AnyCancellable> = []

    private let contentView = SignUpProfileImageSettingView()
    private let nextButton = UIPicplzButton()

    private var log = Logger.of("SignUpNicknamePageViewController")

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "프로필 이미지 업로드"

        setup()
        bind()
    }

    private func setup() {
        view.backgroundColor = .ppWhite

        // MARK: ContentView
        contentView.isUserInteractionEnabled = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15.0),
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 15.0),
            contentView.heightAnchor.constraint(equalToConstant: 450)
        ])

        contentView.profileImageButton.addTarget(self, action: #selector(didSelectButtonTapped), for: .touchUpInside)
        contentView.cameraButton.addTarget(self, action: #selector(didCameraButtonTapped), for: .touchUpInside)

        // MARK: Next Button
        nextButton.setTitle("다음에 설정하기", for: .normal)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        view.addSubview(nextButton)

        NSLayoutConstraint.activate([
            nextButton.heightAnchor.constraint(equalToConstant: 60),
            nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            view.rightAnchor.constraint(equalTo: nextButton.rightAnchor, constant: 15),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 47)
        ])
    }

    private func bind() {
        viewModel.nextButtonTitlePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] title in
                self?.nextButton.setTitle(title, for: .normal)
            }
            .store(in: &subscriptions)

        viewModel.informationLabelTextPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] labelText in
                self?.contentView.setInformationLabelText(labelText)
            }
            .store(in: &subscriptions)

        viewModel.userNicknamePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] nickname in
                self?.contentView.setUserNickname(for: nickname)
            }
            .store(in: &subscriptions)

        viewModel.profileImagePathPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] profileImagePath in
                let image = UIImage(contentsOfFile: profileImagePath.path)
                self?.contentView.profileImageButton.setImage(image, for: .normal)
            }
            .store(in: &subscriptions)
    }

    @objc private func nextButtonTapped() {
        viewModel.nextButtonDidTapped()
    }

    @objc private func didSelectButtonTapped() {
        let defaultAction = UIAlertAction(title: "앨범에서 선택",
                             style: .default) { [weak self] _ in
            self?.presentUIimagePicker(useCamera: false)
        }

        let cancelAction = UIAlertAction(title: "닫기",
                             style: .cancel) { [weak self] _ in
            self?.log.debug("user canceled...")
        }

        // Create and configure the alert controller.
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true)
    }

    @objc private func didCameraButtonTapped() {
        presentUIimagePicker(useCamera: true)
    }

    private func presentUIimagePicker(useCamera: Bool) {
        let picker = UIImagePickerController()
        picker.sourceType = useCamera ? .camera : .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension SignUpProfileImagePageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = "userProfile.jpg"
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        // FIXME: refactor as a Usecase
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
            log.debug("saved image to \(imagePath)")
        }

        viewModel.profileImageSelected(path: imagePath)
        dismiss(animated: true)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
