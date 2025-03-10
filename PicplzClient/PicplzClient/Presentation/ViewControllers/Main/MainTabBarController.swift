//
//  MainTabBarController.swift
//  PicplzClient
//
//  Created by 임영택 on 3/10/25.
//

import UIKit
import OSLog

final class MainTabBarController: UITabBarController {
//    private let homeViewController: UIViewController
//    private let mapViewController: UIViewController
//    private let feedViewController: UIViewController
//    private let chatViewController: UIViewController
//    private let myPageViewController: UIViewController
    private let log = Logger.of("MainTabBarController")
    
    init (viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.registerViewControllers(viewControllers)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func registerViewControllers(_ registringViewControllers: [UIViewController]) {
        var viewContollers: [UIViewController] = []
        
        registringViewControllers.enumerated().forEach { index, viewController in
            if let tabInfo = TabInfo.of(index) {
                viewController.tabBarItem = UITabBarItem(title: tabInfo.title, image: tabInfo.image, tag: index)
                viewContollers.append(viewController)
            } else {
                log.warning("failed to register view controller... unknown index: \(index)")
            }
        }
        
        self.viewControllers = viewContollers
    }
    
    struct TabInfo {
        let title: String
        let image: UIImage?
        
        static func of(_ index: Int) -> TabInfo? {
            switch index {
            case 0:
                return .init(title: "홈", image: UIImage(named: "StarBlack"))
            case 1:
                return .init(title: "지도", image: UIImage(named: "StarBlack"))
            case 2:
                return .init(title: "피드", image: UIImage(named: "StarBlack"))
            case 3:
                return .init(title: "채팅", image: UIImage(named: "StarBlack"))
            case 4:
                return .init(title: "마이페이지", image: UIImage(named: "StarBlack"))
            default:
                return nil
            }
        }
    }
}
