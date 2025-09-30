//
//  OnboardingContentView.swift
//  PicplzClient
//
//  Created by 임영택 on 2/9/25.
//

import UIKit

final class OnboardingContentView: UIView {
    var collectionView: UICollectionView!
    let pageControl = OnboardingPageControl()
    let loginButton = UIButton()

    func setupStyle() {
        translatesAutoresizingMaskIntoConstraints = false

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInsetAdjustmentBehavior = .never // SafeArea를 침범해도 레이아웃을 조정하지 않음

        pageControl.translatesAutoresizingMaskIntoConstraints = false

        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.backgroundColor = .kakaoYellow
        loginButton.setTitle("카카오로 계속하기", for: .normal)
        loginButton.titleLabel?.font = .buttonTitle
        loginButton.setTitleColor(.ppBlack, for: .normal)
        loginButton.setTitleColor(.ppBlack.withAlphaComponent(0.5), for: .highlighted)
    }

    func setupLayout() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalToSystemSpacingBelow: collectionView.bottomAnchor, multiplier: 4.0),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalToSystemSpacingBelow: pageControl.bottomAnchor, multiplier: 4.0),
            loginButton.leftAnchor.constraint(equalToSystemSpacingAfter: leftAnchor, multiplier: 2),
            rightAnchor.constraint(equalToSystemSpacingAfter: loginButton.rightAnchor, multiplier: 2),
            loginButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
