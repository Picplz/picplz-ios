//
//  PhotographerPortfolioDigestView.swift
//  PicplzClient
//
//  Created by 임영택 on 5/12/25.
//

import UIKit

final class PhotographerPortfolioDigestView: UIView {
    let numOfCellsInRow: CGFloat = 3.0
    let photoGridSpacing: CGFloat = 2.0

    // MARK: Views
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .smallTitle
        label.textColor = .ppBlack
        label.text = "포트폴리오"
        return label
    }()

    private var photoGridCollectionView: UICollectionView!

    private let goToDetailButton: UIButton = {
        let button = UIButton()

        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(named: "ChevronLeft")
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 6
        configuration.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0) // 우측 패딩 제거해 차트와 정렬

        button.configuration = configuration

        let attributedString = NSAttributedString(string: "포트폴리오 더보기", attributes: [
            .font: UIFont.caption,
            .foregroundColor: UIColor.ppGrey4
        ])
        button.setAttributedTitle(attributedString, for: .normal)

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.photoGridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollecionViewLayout())
        self.photoGridCollectionView.register(PortfolioImageCell.self, forCellWithReuseIdentifier: PortfolioImageCell.identifier)
        self.photoGridCollectionView.dataSource = self

        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createCollecionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / numOfCellsInRow),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1.0 / numOfCellsInRow)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        group.interItemSpacing = .fixed(photoGridSpacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = photoGridSpacing

        return UICollectionViewCompositionalLayout(section: section)
    }

    // MARK: Views
    private func layout() {
        addSubview(titleLabel)
        addSubview(photoGridCollectionView)
        addSubview(goToDetailButton)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }

        photoGridCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(7)

            let horizontalMargin: CGFloat = 30
            let photoHeight = (UIScreen.main.bounds.width - horizontalMargin) / numOfCellsInRow
            make.height.equalTo(numOfCellsInRow * photoHeight + (numOfCellsInRow - 1) * photoGridSpacing)
        }

        goToDetailButton.snp.makeConstraints { make in
            make.top.equalTo(photoGridCollectionView.snp.bottom).offset(9)
            make.trailing.bottom.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension PhotographerPortfolioDigestView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Int(numOfCellsInRow * numOfCellsInRow)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PortfolioImageCell.identifier, for: indexPath)
                as? PortfolioImageCell else {
            return UICollectionViewCell()
        }

        // FIXME: dummy data
        cell.configure(image: UIImage(named: "ProfileImagePlaceholderRectangle"))

        return cell
    }
}

final class PortfolioImageCell: UICollectionViewCell {
    static let identifier: String = "PortfolioImageCell"
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(image: UIImage?) {
        imageView.image = image
    }

    override func prepareForReuse() {
        imageView.image = nil
    }
}
