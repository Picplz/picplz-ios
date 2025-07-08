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
    private let reviewAnalysisList: [ReviewAnalysis] = [ // FIXME: see `ReviewAnalysis` definition
        .init(description: "사진을 예쁘게 찍어줘요", count: 14),
        .init(description: "포즈 추천을 잘 해줘요", count: 10),
        .init(description: "친절해요", count: 9),
        .init(description: "보정을 잘 해요", count: 5),
    ]
    
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
        label.textColor = .ppBlack
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
        label.textColor = .ppGrey4
        return label
    }()
    private let chartView = PhotographerReviewChartView()
    private let goToDetailButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(named: "ChevronLeft")
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 6
        configuration.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0) // 우측 패딩 제거해 차트와 정렬
        
        button.configuration = configuration
        
        return button
    }()
    
    override init(frame: CGRect) {
        self.reviews = []
        
        super.init(frame: frame)
        
        backgroundColor = .ppWhite
        layout()
        
        chartView.configure(reviewAnalysisList)
    }
    
    func layout() {
        addSubview(titleLabel)
        addSubview(starsWrapperView)
        addSubview(chartView)
        addSubview(goToDetailButton)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
        
        starsWrapperView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
        }
        
        starsWrapperView.addArrangedSubview(starsIndicatorView)
        starsWrapperView.addArrangedSubview(ratingLabel)
        
        chartView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(starsWrapperView.snp.bottom).offset(17)
        }
        
        goToDetailButton.snp.makeConstraints { make in
            make.top.equalTo(chartView.snp.bottom).offset(8)
            make.trailing.bottom.equalToSuperview()
        }
    }
    
    func configure(reviews: [PhotographerReview]) {
        self.reviews = reviews
        starsIndicatorView.configure(rating: rating)
        ratingLabel.text = "\(rating.roundedToHalf())"
        
        let totalCount = reviews.reduce(0) { partialResult, review in
            partialResult + review.likesCount
        }
        
        let attributedString = NSAttributedString(string: "전체 리뷰 보러가기 (\(totalCount))", attributes: [
            .font: UIFont.caption,
            .foregroundColor: UIColor.ppGrey4
        ])
        goToDetailButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// FIXME: 데이터 설계 필요 / 백엔드에서 어떻게 처리하는지?
struct ReviewAnalysis {
    let description: String
    let count: Int
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
