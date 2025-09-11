//
//  PhotographerReviewChartView.swift
//  PicplzClient
//
//  Created by 임영택 on 5/6/25.
//

import UIKit
import SnapKit

final class PhotographerReviewChartView: UIView {
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }

    func configure(_ reviews: [ReviewAnalysis]) {
        stackView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }

        let totalCount = reviews.reduce(0) { partialResult, review in
            partialResult + review.count
        }

        reviews.forEach { review in
            let barView = PhotographerReviewChartBar(
                description: review.description,
                count: review.count,
                total: totalCount
            )

            stackView.addArrangedSubview(barView)
        }
    }
}

private final class PhotographerReviewChartBar: UIView {
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .ppGrey1
        view.layer.borderColor = UIColor.ppGrey2.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        return view
    }()

    let foregroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .ppGreend100
        view.layer.cornerRadius = 5
        return view
    }()

    let bulletImageView: UIImageView = {
        let bulletCustomColor = UIColor(red: 217.0 / 255.0, green: 217.0 / 255.0, blue: 217.0 / 255.0, alpha: 1.0) // #D9D9D9

        let imageView = UIImageView(image: UIImage(systemName: "square.fill"))
        imageView.tintColor = bulletCustomColor
        return imageView
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .body
        label.textColor = .ppBlack
        return label
    }()

    let countLabel: UILabel = {
        let label = UILabel()
        label.font = .captionSemiBold
        label.textColor = .ppGrey4
        return label
    }()

    private var ratio: Float

    init(description: String, count: Int, total: Int) {
        self.ratio = Float(count) / Float(total)
        super.init(frame: .zero)

        layout()
        self.descriptionLabel.text = description
        self.countLabel.text = String(count)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        addSubview(backgroundView)
        addSubview(foregroundView)
        addSubview(bulletImageView)
        addSubview(descriptionLabel)
        addSubview(countLabel)

        snp.makeConstraints { make in
            make.height.equalTo(39)
        }

        backgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview()
        }

        foregroundView.snp.makeConstraints { make in
            make.leading.top.bottom.equalTo(backgroundView)
            make.width.equalTo(backgroundView.snp.width).multipliedBy(ratio)
        }

        bulletImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(9)
            make.centerY.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(bulletImageView.snp.trailing).offset(7)
            make.centerY.equalToSuperview()
        }

        countLabel.snp.makeConstraints { make in
            make.trailing.equalTo(backgroundView.snp.trailing).offset(-12)
            make.centerY.equalToSuperview()
        }
    }
}
