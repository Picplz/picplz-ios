//
//  OnboardingContentView.swift
//  PicplzClient
//
//  Created by 임영택 on 2/9/25.
//

import UIKit

final class OnboardingContentView: UIView {
    var collectionView: UICollectionView!
    let pageControl = UIPageControl()
    let loginButton = UIButton()
    
    func setupStyle() {
        translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.backgroundColor = Colors.kakaoYellow
        loginButton.setTitle("카카오로 계속하기", for: .normal)
        loginButton.titleLabel?.font = Fonts.buttonTitle
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.setTitleColor(.black.withAlphaComponent(0.5), for: .highlighted)
    }
    
    func setupLayout() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
        ])
        
        addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 12),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 12),
            loginButton.leftAnchor.constraint(equalToSystemSpacingAfter: leftAnchor, multiplier: 2),
            rightAnchor.constraint(equalToSystemSpacingAfter: loginButton.rightAnchor, multiplier: 2),
            loginButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
