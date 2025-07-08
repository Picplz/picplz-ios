//
//  UserAvatarView.swift
//  PicplzClient
//
//  Created by 임영택 on 3/12/25.
//

import UIKit

class PhotographerAvatarView: UIView {
    let avatarImageView = UIImageView()
    let nameLabel = UILabel()
    let activeIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .ppGreend100
        view.layer.cornerRadius = 4
        return view
    }()
    let distanceLabel = UILabel()
    
    init(of photograper: PhotograperAvatarData) {
        super.init(frame: .zero)
        style(for: photograper)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func style(for data: PhotograperAvatarData) {
        translatesAutoresizingMaskIntoConstraints = false
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        activeIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        avatarImageView.layer.cornerRadius = 37
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.ppBlack.cgColor
        avatarImageView.image = data.image
        
        nameLabel.font = .caption
        nameLabel.textColor = .ppBlack
        nameLabel.text = "\(data.name) 작가"
        nameLabel.textAlignment = .center
        
        activeIndicatorView.isHidden = !data.active
        
        distanceLabel.font = .caption
        distanceLabel.textColor = .ppGrey3
        distanceLabel.textAlignment = .center
        if let distance = data.distance,
           let unit = data.distanceUnit?.displayString {
            distanceLabel.text = "\(distance)\(unit)"
        } else {
            distanceLabel.text = nil
        }
        
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(activeIndicatorView)
        addSubview(distanceLabel)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor),
            avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 74),
            avatarImageView.heightAnchor.constraint(equalToConstant: 74),
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 6),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            activeIndicatorView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 6),
            activeIndicatorView.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 3),
            activeIndicatorView.widthAnchor.constraint(equalToConstant: 8),
            activeIndicatorView.heightAnchor.constraint(equalToConstant: 8),
        ])
        
        NSLayoutConstraint.activate([
            distanceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            distanceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            distanceLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
