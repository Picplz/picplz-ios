//
//  OnboardingPageControl.swift
//  PicplzClient
//
//  Created by 임영택 on 2/10/25.
//

import UIKit

final class OnboardingPageControl: UIView {
    private let stackView = UIStackView()
    var numberOfPages = 0 {
        didSet {
            stackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
            for _ in 0..<numberOfPages {
                stackView.addArrangedSubview(DotView(frame: CGRect(x: 0, y: 0, width: 12, height: 12)))
            }
            currentPage = 0
        }
    }
    var currentPage = 0 {
        didSet {
            guard currentPage < stackView.arrangedSubviews.count,
                  let prevEnabledDot = stackView.arrangedSubviews[oldValue] as? DotView,
                  let shouldEnableDot = stackView.arrangedSubviews[currentPage] as? DotView else { return }
            
            prevEnabledDot.enabled = false
            shouldEnableDot.enabled = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setup() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.spacing = 9.0
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    final class DotView: UIView {
        var enabled: Bool = false {
            didSet {
                updateAppearance()
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            layer.cornerRadius = frame.height / 2 // Half of height and width
            updateAppearance()
        }
        
        required init?(coder: NSCoder) {
            fatalError()
        }
        
        override var intrinsicContentSize: CGSize {
            .init(width: 12, height: 12)
        }
        
        func updateAppearance() {
            if enabled {
                backgroundColor = .black
                layer.borderWidth = .zero
                layer.borderColor = UIColor.clear.cgColor
            } else {
                backgroundColor = .white
                layer.borderWidth = 0.8
                layer.borderColor = UIColor.black.cgColor
            }
        }
    }
}
