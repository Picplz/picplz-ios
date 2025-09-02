//
//  CustomTabBar.swift
//  PicplzClient
//
//  Created by 임영택 on 9/2/25.
//

import UIKit

final class CustomTabBar: UIView {
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let horizontalPadding: CGFloat = 24
    private let verticalPadding: CGFloat = 15
    private let tabBarHeight: CGFloat = 84
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: horizontalPadding),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -horizontalPadding),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: verticalPadding),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -verticalPadding),
            self.heightAnchor.constraint(equalToConstant: self.tabBarHeight),
        ])
    }
    
    func addArangedTabBarItem(_ item: UITabBarItem) {
        let view = CustomTabBarItem(tabBarItem: item)
        stackView.addArrangedSubview(view)
    }
}
