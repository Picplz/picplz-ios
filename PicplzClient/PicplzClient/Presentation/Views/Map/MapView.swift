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
        label.textColor = .ppGrey5
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
        label.textColor = .ppBlack
        return label
    }()
    
    var photographerAvatarModels: [PhotograperAvatarData] = [] {
        didSet {
            photographerAvatarViews = photographerAvatarModels.map{ model in
                PhotographerAvatarView(of: model)
            }
        }
    }
    var photographerAvatarViews: [PhotographerAvatarView] = [] {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            
            photographerAvatarViews.enumerated()
                .forEach { index, view in
                    view.translatesAutoresizingMaskIntoConstraints = false
                    addSubview(view)
                    layoutAvatarView(index: index, view: view)
                }
        }
    }
    
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
    }
    
    private func layout() {
        addSubview(myAvatarView)
        addSubview(searchingMessageLabelView)
        addSubview(myLabelView)
        addSubview(backgroundView)
        
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
    }
    
    private func layoutAvatarView(index: Int, view: UIView) {
        var xConstant: CGFloat = 0
        var yConstant: CGFloat = 0
        
        switch index {
        case 0:
            xConstant = -72
            yConstant = -112
        case 1:
            xConstant = 72
            yConstant = -148
        case 2:
            xConstant = 188
            yConstant = -36
        case 3:
            xConstant = 142
            yConstant = 112
        case 4:
            xConstant = 24
            yConstant = 200
        case 5:
            xConstant = -82
            yConstant = 162
        default:
            xConstant = 0
            yConstant = 0
        }
        
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: myAvatarView.centerXAnchor, constant: xConstant),
            view.centerYAnchor.constraint(equalTo: myAvatarView.centerYAnchor, constant: yConstant),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
