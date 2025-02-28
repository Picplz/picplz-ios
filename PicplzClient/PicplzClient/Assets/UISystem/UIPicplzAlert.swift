//
//  UIPicplzAlert.swift
//  PicplzClient
//
//  Created by 임영택 on 2/20/25.
//

import UIKit

final class UIPicplzAlert: UIView {
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    var contentText: NSMutableAttributedString? {
        didSet {
            guard let contentText = contentText else { return }
            setTextToContentLabel(text: contentText)
        }
    }
    
    private let dimmedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        return view
    }()
    
    private let alertWrapperView: UIView = {
        let view = UIView(frame: .init(x: 0, y: 0, width: 304, height: 112))
        view.backgroundColor = .picplzWhite
        view.layer.cornerRadius = 5.0
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontFamily.pretendardBold.rawValue, size: 14)!
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .caption
        label.numberOfLines = 0
        return label
    }()
    
    private let informationIcon: UIImageView = UIImageView(image: UIImage(named: "InformationIcon"))
    
    var animationDuration: CGFloat = 0.2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didBackgroundTapped))
        dimmedBackgroundView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        dimmedBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dimmedBackgroundView)
        NSLayoutConstraint.activate([
            dimmedBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            dimmedBackgroundView.leftAnchor.constraint(equalTo: leftAnchor),
            dimmedBackgroundView.rightAnchor.constraint(equalTo: rightAnchor),
            dimmedBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        alertWrapperView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(alertWrapperView)
        NSLayoutConstraint.activate([
            alertWrapperView.topAnchor.constraint(equalTo: topAnchor, constant: 195.0),
            alertWrapperView.leftAnchor.constraint(equalTo: leftAnchor, constant: 36.0),
            rightAnchor.constraint(equalTo: alertWrapperView.rightAnchor, constant: 36.0),
            alertWrapperView.heightAnchor.constraint(equalToConstant: 115.0),
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        alertWrapperView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: alertWrapperView.topAnchor, constant: 20),
            titleLabel.leftAnchor.constraint(equalTo: alertWrapperView.leftAnchor, constant: 20),
            alertWrapperView.rightAnchor.constraint(greaterThanOrEqualTo: titleLabel.rightAnchor, constant: 40),
        ])
        
        informationIcon.translatesAutoresizingMaskIntoConstraints = false
        alertWrapperView.addSubview(informationIcon)
        NSLayoutConstraint.activate([
            informationIcon.topAnchor.constraint(equalTo: alertWrapperView.topAnchor, constant: 9.0),
            alertWrapperView.rightAnchor.constraint(equalTo: informationIcon.rightAnchor, constant: 10.0),
            informationIcon.widthAnchor.constraint(equalToConstant: 16.0),
            informationIcon.heightAnchor.constraint(equalToConstant: 17.0),
        ])
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        alertWrapperView.addSubview(contentLabel)
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            contentLabel.leftAnchor.constraint(equalTo: alertWrapperView.leftAnchor, constant: 20),
            alertWrapperView.rightAnchor.constraint(greaterThanOrEqualTo: contentLabel.rightAnchor, constant: 40),
        ])
    }
    
    private func setTextToContentLabel(text attributedText: NSMutableAttributedString) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .left
        
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        
        contentLabel.attributedText = attributedText
    }
    
    @objc private func didBackgroundTapped() {
        close()
    }
    
    func close() {
        self.alpha = 1
        UIView.animate(withDuration: self.animationDuration) {
            self.alpha = 0
        } completion: { _ in
            self.isHidden = true
        }
    }
    
    func open() {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: self.animationDuration) {
            self.alpha = 1
        }
    }
}
