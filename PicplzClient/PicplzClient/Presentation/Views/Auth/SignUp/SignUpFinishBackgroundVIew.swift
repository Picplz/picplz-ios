//
//  SignUpFinishBackgroundVIew.swift
//  PicplzClient
//
//  Created by 임영택 on 2/25/25.
//

import UIKit

final class SignUpFinishBackgroundVIew: UIView {
    private let star1ImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "StarWhite"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let star2ImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "StarBlack"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let star3ImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "StarBlack"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func style() {
        star1ImageView.translatesAutoresizingMaskIntoConstraints = false
        star2ImageView.translatesAutoresizingMaskIntoConstraints = false
        star3ImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layout() {
        addSubview(star1ImageView)
        NSLayoutConstraint.activate([
            star1ImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20.0),
            star1ImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 57.0),
            star1ImageView.widthAnchor.constraint(equalToConstant: 77.0),
            star1ImageView.heightAnchor.constraint(equalToConstant: 77.0),
        ])
        
        addSubview(star2ImageView)
        NSLayoutConstraint.activate([
            star2ImageView.topAnchor.constraint(equalTo: star1ImageView.topAnchor, constant: 34.0),
            star2ImageView.leftAnchor.constraint(equalTo: star1ImageView.rightAnchor, constant: 7.0),
            star2ImageView.widthAnchor.constraint(equalToConstant: 24.37),
            star2ImageView.heightAnchor.constraint(equalToConstant: 24.53),
        ])
        
        addSubview(star3ImageView)
        NSLayoutConstraint.activate([
            star3ImageView.topAnchor.constraint(equalTo: star1ImageView.bottomAnchor, constant: 157.0),
            star3ImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -64.0),
            star3ImageView.widthAnchor.constraint(equalToConstant: 47.93),
            star3ImageView.heightAnchor.constraint(equalToConstant: 48.25),
        ])
    }
}
