//
//  UIPickplzNavigationController.swift
//  PicplzClient
//
//  Created by 임영택 on 2/28/25.
//

import UIKit
import OSLog

final class UIPickplzNavigationController: UINavigationController {
    private let log = Logger.of("UIPickplzNavigationController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        self.delegate = self
    }
    
    private func setUpNavigationBar() {
        // MARK: Set back button's image
        let backButtonBackgroundImage = UIImage(named: "BackButton")
        let barAppearance = UINavigationBar.appearance(whenContainedInInstancesOf: [UIPickplzNavigationController.self]) // returns proxy for setting appearance
        barAppearance.backIndicatorImage = backButtonBackgroundImage
        barAppearance.backIndicatorTransitionMaskImage = backButtonBackgroundImage
        
        // MARK: Set tint color
        barAppearance.tintColor = .black
        
        // MARK: Set title text attributes
        if let font = UIFont(name: FontFamily.pretendardRegular.rawValue, size: 14) {
            barAppearance.titleTextAttributes = [.font: font]
        } else {
            log.warning("font missing... name=\(FontFamily.pretendardRegular.rawValue) size=\(14)")
            barAppearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 14)]
        }
        
        // MARK: Pull down back button little bit
        let barButtonApperance = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UIPickplzNavigationController.self])
        barButtonApperance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: 2.5), for: .default)
        
        // MARK: Remove back button's title
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButton
    }
}

extension UIPickplzNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // MARK: Remove current viewController's back button title
         viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
