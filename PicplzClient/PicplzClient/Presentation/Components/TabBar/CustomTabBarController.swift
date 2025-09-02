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
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isHidden = true // 원래 탭바는 숨긴다
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(customTabBar)
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
