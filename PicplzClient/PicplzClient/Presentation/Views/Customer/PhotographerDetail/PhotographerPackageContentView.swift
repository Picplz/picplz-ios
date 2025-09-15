//
//  PhotographerPackageContentView.swift
//  PicplzClient
//
//  Created by 임영택 on 6/21/25.
//

import UIKit
import SnapKit

class PhotographerPackageContentView: UIView {
    // MARK: Views
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .custom(.pretendardBold, size: 22)
        label.textColor = .ppBlack
        return label
    }()

    private let rowStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()

    // MARK: Option
    private let imageHeight: CGFloat = 160

    override init(frame: CGRect) {
        super.init(frame: frame)

        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayout() {
        addSubview(imageView)
        addSubview(priceLabel)
        addSubview(rowStackView)

        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(imageHeight)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
        }

        rowStackView.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(23)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    func configure(for package: PhotographerPackage?) {
        guard let package = package else {
            return
        }

        imageView.image = UIImage(resource: .packageBannerExample) // TODO: replace to real server resource in future

        priceLabel.text = "\(convertPriceToString(package.price))원"

        rowStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        rowStackView.addArrangedSubview(
            createRowView(title: "촬영 컷수", content: package.numberOfPhots)
        )

        rowStackView.addArrangedSubview(
            createRowView(title: "촬영 시간", content: package.shootingTimes)
        )

        rowStackView.addArrangedSubview(
            createRowView(title: "보정 여부", content: package.inclueAdjust)
        )

        rowStackView.addArrangedSubview(
            createRowView(title: "기타 안내", content: package.extraNotice)
        )
    }
}

extension PhotographerPackageContentView {
    private func createRowView(title: String, content: String) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .captionSemiBold
        titleLabel.textColor = .ppGrey6
        titleLabel.setContentHuggingPriority(.required, for: .horizontal) // 제목 레이블은 폭 변동 없도록 지정
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        let contentLabel = UILabel()
        contentLabel.text = content
        contentLabel.font = .caption
        contentLabel.textColor = .ppGrey4
        contentLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        contentLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 14
        stackView.alignment = .center
        stackView.distribution = .fill

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(contentLabel)

        return stackView
    }

    private func convertPriceToString(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "N/A"
    }
}
