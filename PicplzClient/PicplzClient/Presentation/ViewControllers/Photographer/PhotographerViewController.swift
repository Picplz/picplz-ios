//
//  PhotographerViewController.swift
//  PicplzClient
//
//  Created by 임영택 on 3/8/25.
//

import UIKit

protocol PhotographerViewControllerDelegate: AnyObject {
    func switchToCustomer()
    func logOut()
}

final class PhotographerViewController: UIViewController {
    let label = UILabel()
    let switchButton = UIButton(type: .system)
    let logOutButton = UIButton(type: .system)

    weak var delegate: PhotographerViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupStyle()
        setupLayout()
    }

    private func setupStyle() {
        view.backgroundColor = .ppWhite

        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "작가"

        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.setTitle("전환하기", for: .normal)
        switchButton.addTarget(self, action: #selector(switchButtonTapped), for: .touchUpInside)

        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.setTitle("로그아웃", for: .normal)
        logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
    }

    private func setupLayout() {
        view.addSubview(label)
        view.addSubview(switchButton)
        view.addSubview(logOutButton)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            view.rightAnchor.constraint(equalTo: label.rightAnchor, constant: 8)
        ])

        NSLayoutConstraint.activate([
            switchButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            switchButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            view.rightAnchor.constraint(equalTo: switchButton.rightAnchor, constant: 8)
        ])

        NSLayoutConstraint.activate([
            logOutButton.topAnchor.constraint(equalTo: switchButton.bottomAnchor, constant: 8),
            logOutButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            view.rightAnchor.constraint(equalTo: logOutButton.rightAnchor, constant: 8)
        ])
    }

    @objc private func switchButtonTapped() {
        delegate?.switchToCustomer()
    }

    @objc private func logOutButtonTapped() {
        delegate?.logOut()
    }
}
