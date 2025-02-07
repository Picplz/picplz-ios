//
//  MainViewController.swift
//  PicplzClient
//
//  Created by 임영택 on 2/7/25.
//

import UIKit

final class MainViewController: UIViewController {
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupLayout()
    }
    
    private func setupStyle() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "MainView"
    }
    
    private func setupLayout() {
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
