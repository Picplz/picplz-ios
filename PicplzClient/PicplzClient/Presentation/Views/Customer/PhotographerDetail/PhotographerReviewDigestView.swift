//
//  PhotographerReviewDigestView.swift
//  PicplzClient
//
//  Created by 임영택 on 5/5/25.
//

import UIKit
import SnapKit

final class PhotographerReviewDigestView: UIView {
    private var reviews: [PhotographerReview]
    
    private var rating: Float {
        let sum = reviews.reduce(0.0) { partialResult, review in
            return partialResult + review.rating
        }
        
        return sum / Float(reviews.count)
    }
    
    // MARK: Views
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .smallTitle
        label.textColor = .picplzBlack
        label.text = "촬영 만족도"
        return label
    }()
    private let starsWrapperView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        return stackView
    }()
    private let starsIndicatorView = RatingStarsIndicatorView()
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .bodySemibold
        label.textColor = .grey4
        return label
    }()
    
    override init(frame: CGRect) {
        self.reviews = []
        
        super.init(frame: frame)
        
        backgroundColor = .picplzWhite
        layout()
    }
    
    func layout() {
        addSubview(titleLabel)
        addSubview(starsWrapperView)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
        
        starsWrapperView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
            make.bottom.equalToSuperview().inset(20)
        }
        
        starsWrapperView.addArrangedSubview(starsIndicatorView)
        starsWrapperView.addArrangedSubview(ratingLabel)
    }
    
    func configure(reviews: [PhotographerReview]) {
        self.reviews = reviews
        starsIndicatorView.configure(rating: rating)
        ratingLabel.text = "\(rating.roundedToHalf())"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate final class RatingStarsIndicatorView: UIView {
    let starSize: CGFloat = 23
    let maxRating: Float = 5
    
    let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        renderStars(full: 0, half: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(rating: Float) {
        let ratingRounded = rating.roundedToHalf()
        
        let numberOfFullStars: Int = Int(floor(ratingRounded))
        let numberOfHalfStar: Int = ratingRounded - Float(numberOfFullStars) > .zero ? 1 : 0
        
        renderStars(full: numberOfFullStars, half: numberOfHalfStar)
    }
    
    private func layout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func renderStars(full numberOfFullStars: Int, half numberOfHalfStar: Int) {
        stackView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
        
        (0..<numberOfFullStars).forEach { _ in
            let imageView = UIImageView(image: UIImage(named: "FullStar"))
            stackView.addArrangedSubview(imageView)
        }
        
        (0..<numberOfHalfStar).forEach { _ in
            let imageView = UIImageView(image: UIImage(named: "HalfStar"))
            stackView.addArrangedSubview(imageView)
        }
        
        let remainStars = Int(maxRating) - (numberOfFullStars + numberOfHalfStar)
        (0..<remainStars).forEach { _ in
            let imageView = UIImageView(image: UIImage(named: "EmptyStar"))
            stackView.addArrangedSubview(imageView)
        }
    }
}

fileprivate extension Float {
    func roundedToHalf() -> Float {
        return (self * 2.0).rounded() / 2.0
    }
}
