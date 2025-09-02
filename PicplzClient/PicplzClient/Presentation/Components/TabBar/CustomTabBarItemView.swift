//
//  CustomTabBarItem.swift
//  PicplzClient
//
//  Created by 임영택 on 9/2/25.
//

import UIKit

final class CustomTabBarItemView: UIView {
    // MARK: - Properties
    let tabBarItem: UITabBarItem
    let didTap: (_ index: Int) -> Void
    var isSelected: Bool = false {
        didSet {
            setAppearance(isActive: isSelected)
        }
    }
    
    // MARK: - Constraints
    private let viewSize: CGFloat = 54
    private let tabBarItemLabelFont: UIFont = UIFont.custom(.pretendardRegular, size: 12)
    
    // MARK: - SubViews
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
    
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(tabBarItem: UITabBarItem, didTap: @escaping (_ index: Int) -> Void) {
        self.tabBarItem = tabBarItem
        self.didTap = didTap
        super.init(frame: .zero)
        setupLayout()
        
        // Set Gesture Recognizer
        let tapGesture = UITapGestureRecognizer()
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
    }
    
    private func setupLayout() {
        // Set current view
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: viewSize),
            self.heightAnchor.constraint(equalToConstant: viewSize),
        ])
        
        // Set stackView
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        // Set arranged views
        stackView.addArrangedSubview(UIImageView(image: tabBarItem.image))
        
        let label = UILabel()
        label.text = tabBarItem.title
        label.font = tabBarItemLabelFont
        stackView.addArrangedSubview(label)
    }
    
    private func setAppearance(isActive: Bool) {
        if isActive {
            self.stackView.arrangedSubviews.forEach {
                if let label = $0 as? UILabel {
                    label.textColor = .ppBlack
                }
                
                if let imageView = $0 as? UIImageView {
                    imageView.image = tabBarItem.selectedImage
                }
            }
            return
        }
        
        self.stackView.arrangedSubviews.forEach {
            if let label = $0 as? UILabel {
                label.textColor = .ppGrey3
            }
            
            if let imageView = $0 as? UIImageView {
                imageView.image = tabBarItem.image
            }
        }
    }
}

extension CustomTabBarItemView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        didTap(tabBarItem.tag)
        return true
    }
}
