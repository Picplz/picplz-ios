//
//  MapView.swift
//  PicplzClient
//
//  Created by 임영택 on 3/12/25.
//

import UIKit

final class MapView: UIView {
    private let backgroundView = MapBackgroundView()
    
    let searchingMessageLabelView: UILabel = {
        let label = UILabel()
        label.text = "주변 작가 찾는 중..."
        label.textAlignment = .center
        label.font = .caption
        label.textColor = .grey5
        return label
    }()
    private let myAvatarView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "UserAvatar"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 32
        return imageView
    }()
    private let myLabelView: UILabel = {
        let label = UILabel()
        label.text = "나"
        label.textAlignment = .center
        label.font = .captionSemiBold
        label.textColor = .picplzBlack
        return label
    }()
    
    private var photographerAvatarView1: PhotographerAvatarView?
    private var photographerAvatarView2: PhotographerAvatarView?
    private var photographerAvatarView3: PhotographerAvatarView?
    private var photographerAvatarView4: PhotographerAvatarView?
    private var photographerAvatarView5: PhotographerAvatarView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    
    private func style() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .clear
        myAvatarView.translatesAutoresizingMaskIntoConstraints = false
        searchingMessageLabelView.translatesAutoresizingMaskIntoConstraints = false
        myLabelView.translatesAutoresizingMaskIntoConstraints = false
        
        photographerAvatarView1 = PhotographerAvatarView(of: .init(name: "짱구", distance: 200, active: true, image: UIImage(named: "ProfileImagePlaceholder")!))
        photographerAvatarView1?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layout() {
        addSubview(myAvatarView)
        addSubview(searchingMessageLabelView)
        addSubview(myLabelView)
        addSubview(backgroundView)
        if let avatar1 = photographerAvatarView1 {
            addSubview(avatar1)
        }
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: rightAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            myAvatarView.centerXAnchor.constraint(equalTo: centerXAnchor),
            myAvatarView.centerYAnchor.constraint(equalTo: centerYAnchor),
            myAvatarView.widthAnchor.constraint(equalToConstant: 64),
            myAvatarView.heightAnchor.constraint(equalToConstant: 64),
        ])
        
        NSLayoutConstraint.activate([
            searchingMessageLabelView.bottomAnchor.constraint(equalTo: myAvatarView.topAnchor, constant: -3),
            searchingMessageLabelView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            myLabelView.topAnchor.constraint(equalTo: myAvatarView.bottomAnchor, constant: 3),
            myLabelView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        if let avatar1 = photographerAvatarView1 {
            NSLayoutConstraint.activate([
                avatar1.bottomAnchor.constraint(equalTo: myAvatarView.topAnchor, constant: -24),
                avatar1.rightAnchor.constraint(equalTo: myAvatarView.leftAnchor, constant: -48),
            ])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
