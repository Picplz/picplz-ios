//
//  CustomTabBarController.swift
//  PicplzClient
//
//  Created by 임영택 on 9/2/25.
//

import UIKit

final class CustomTabBarController: UITabBarController {
    let customTabBar = CustomTabBar()

    override var viewControllers: [UIViewController]? {
        didSet {
            if let viewControllers {
                viewControllers.forEach { vc in
                    customTabBar.addArangedTabBarItem(vc.tabBarItem)
                }

                customTabBar.selectTap(at: 0) // 세팅 후 0번 아이템 선택
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isHidden = true // 원래 탭바는 숨긴다

        setupLayout()

        customTabBar.didSelectTab = { [weak self] index in
            self?.selectedIndex = index
        }
    }

    private func setupLayout() {
        view.addSubview(customTabBar)
        customTabBar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
