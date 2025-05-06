//
//  CustomerMapBottomSheetContentView.swift
//  PicplzClient
//
//  Created by 임영택 on 3/23/25.
//

import UIKit
import SnapKit
import SwiftUI

class CustomerMapBottomSheetContentView: UIView {
    let topMargin: CGFloat = 28.0
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    // FIXME: should be injected from outside
    private var photographerFilters: [MapListFilter] = MapListFilter.photographerFilters
    private var hashTagFilters: [MapListFilter] = MapListFilter.hashTagFilters
    private var photographerList: [PhotographerDetail] = PhotographerDetail.debugList
    
    var onPhotographerSelected: (_ photographerId: Int) -> Void = { _ in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .picplzWhite
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.collectionViewLayout = getLayout()
        
        collectionView.register(FilterItemCell.self, forCellWithReuseIdentifier: "FilterItemCell")
        collectionView.register(OrderItemCell.self, forCellWithReuseIdentifier: "OrderItemCell")
        collectionView.register(PhotographerItemCell.self, forCellWithReuseIdentifier: "PhotographerItemCell")
        collectionView.register(SeparatorView.self, forSupplementaryViewOfKind: "SeparatorKind", withReuseIdentifier: "Separator")
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .filter(let filter):
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterItemCell", for: indexPath) as? FilterItemCell {
                    cell.configure(filter: filter) { [weak self] filter in
                        self?.didFilterButtonTapped(filter: filter)
                    }
                    return cell
                }
            case .order:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderItemCell", for: indexPath) as? OrderItemCell {
                    cell.configure { [weak self] orderBy in
                        self?.didOrderBySelected(order: orderBy)
                    }
                    return cell
                }
            case .photographerList(let photographer):
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotographerItemCell", for: indexPath) as? PhotographerItemCell {
                    cell.configure(photographer: photographer) { [weak self] photographer in
                        self?.didPhotographerSelected(photographer: photographer)
                    }
                    return cell
                }
            }
            
            return nil
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            if let separatorView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Separator", for: indexPath) as? SeparatorView {
                return separatorView
            }
            
            return nil
        }
        
        applyDatasource()
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
                .offset(37 - topMargin)
            make.bottom.equalToSuperview()
            make.horizontalEdges
                .equalToSuperview()
                .inset(14)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { section, env in
            switch section {
            case 3: // 작가 리스트
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(110))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
                let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: "SeparatorKind", alignment: .bottom)
                group.supplementaryItems = [footer]
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 20

                return section
            case 0: // 가장 상단 필터
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(120), heightDimension: .absolute(25))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(1000), heightDimension: .estimated(25))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(8)
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 8
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 11, trailing: 0)
                
                return section
            default: // 그 외
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .absolute(25)) // 너비를 충분히 크게 주지 않으면 버튼이 selected 상태가 될 때 레이블이 줄바꿈됨
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(1000), heightDimension: .estimated(25))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(8)
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 8
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 11, trailing: 0)

                return section
            }
        }
    }
    
    func applyDatasource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.photographerFilter, .hashTagFilter, .orderControl, .photographerList])
        snapshot.appendItems(photographerFilters.map({ Item.filter($0) }), toSection: .photographerFilter)
        snapshot.appendItems(hashTagFilters.map({ Item.filter($0) }), toSection: .hashTagFilter)
        snapshot.appendItems([.order], toSection: .orderControl)
        snapshot.appendItems(photographerList.map({ Item.photographerList($0) }), toSection: .photographerList)
        dataSource.apply(snapshot)
    }
    
    private func didFilterButtonTapped(filter: MapListFilter) {
        // TODO: Connect to viewModel
        // TODO: Make be selected only one
        guard filter.type == .hashTagFilter else { return }
        hashTagFilters = hashTagFilters.map { item in
            if item == filter {
                return MapListFilter(
                    filterId: item.filterId,
                    filterTitle: item.filterTitle,
                    image: item.image,
                    type: item.type,
                    isSelected: !item.isSelected
                )
            }
            
            // MARK: 하나의 필터만 선택 가능
            if !filter.isSelected && item.isSelected {
                return MapListFilter(
                    filterId: item.filterId,
                    filterTitle: item.filterTitle,
                    image: item.image,
                    type: item.type,
                    isSelected: false
                )
            }
            
            return item
        }
        applyDatasource()
    }
    
    private func didOrderBySelected(order: MapListOrderBy) {
        // TODO: Connect to viewModel
        print(order)
    }
    
    private func didPhotographerSelected(photographer: PhotographerDetail) {
        // TODO: Connect to viewModel
        onPhotographerSelected(photographer.id)
    }
}

fileprivate enum Section {
    case photographerFilter
    case hashTagFilter
    case orderControl
    case photographerList
}

fileprivate enum Item: Hashable {
    case filter(MapListFilter)
    case order
    case photographerList(PhotographerDetail)
}




// FIXME: separate file
fileprivate final class PhotographerItemCell: UICollectionViewCell {
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let infoLabel = UILabel()
    
    private let ourTownBadgeView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(red: 227 / 255, green: 239 / 255, blue: 249 / 255, alpha: 1)
        
        let label = UILabel()
        label.text = "우리 동네 작가"
        label.font = UIFont.init(name: FontFamily.pretendardSemiBold.rawValue, size: 9)
        label.textColor = .init(red: 0, green: 135 / 255, blue: 218 / 255, alpha: 1)
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view).inset(4)
            make.verticalEdges.equalTo(view).inset(2)
        }
        
        return view
    }()
    
    private let directShootBadge: UIView = {
        let view = UIView()
        
        let symbolView = UIImageView()
        symbolView.image = UIImage(named: "CircleSymbol")!
        
        let label = UILabel()
        label.text = "바로촬영"
        label.font = .captionSemiBold
        label.textColor = .init(red: 128 / 255, green: 192 / 255, blue: 84 / 255, alpha: 1)
        
        view.addSubview(symbolView)
        view.addSubview(label)
        
        symbolView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.centerY.equalTo(view.snp.centerY)
            make.height.equalTo(10)
            make.width.equalTo(10)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(symbolView.snp.trailing).offset(4)
            make.trailing.equalTo(view.snp.trailing)
            make.verticalEdges.equalTo(view)
        }
        
        return view
    }()
    
    private let scrollView = UIScrollView()
    
    private let tagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private var photographer: PhotographerDetail?
    private var didSelectHandler: ((_ orderBy: PhotographerDetail) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func style() {
        profileImageView.layer.cornerRadius = 5
        profileImageView.layer.borderColor = UIColor.grey2.cgColor
        profileImageView.layer.borderWidth = 1
        
        nameLabel.font = .middleTitleSemiBold
        nameLabel.textColor = .picplzBlack
        
        infoLabel.font = .body
        infoLabel.textColor = .grey4
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func layout() {
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(infoLabel)
        addSubview(ourTownBadgeView)
        addSubview(directShootBadge)
        addSubview(scrollView)
        scrollView.addSubview(tagStackView)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalToSuperview()
            make.height.width.equalTo(90)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.leading.equalTo(nameLabel.snp.leading)
        }
        
        ourTownBadgeView.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(3)
            make.centerY.equalTo(nameLabel.snp.centerY)
        }
        
        directShootBadge.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing)
            make.centerY.equalTo(nameLabel.snp.centerY)
        }
        
        scrollView.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(profileImageView.snp.bottom)
            make.height.equalTo(30)
        }
        
        tagStackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.height.equalTo(scrollView.snp.height)
        }
    }
    
    override func prepareForReuse() {
        self.tagStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    private func getTagBadge(title: String) -> UIView {
        let view = UIView()
        view.backgroundColor = .grey2
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        
        let label = UILabel()
        label.text = title
        label.font = .body
        label.textColor = .grey4
        
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(12)
        }
        
        return view
    }
    
    @objc private func cellTapped() {
        guard let photographer = photographer else { return }
        didSelectHandler?(photographer)
    }
    
    func configure(photographer: PhotographerDetail, didSelectHandler: ((_ photographer: PhotographerDetail) -> Void)?) {
        self.photographer = photographer
        self.didSelectHandler = didSelectHandler
        
        profileImageView.image = photographer.image != nil ? photographer.image : UIImage(named: "ProfileImagePlaceholderRectangle")
        nameLabel.text = "\(photographer.name) 작가"
        infoLabel.text = "\(photographer.distanceIntMeters)m / 도보 \(photographer.walkTimeInMinutes)분"
        
        ourTownBadgeView.isHidden = !photographer.isOurTownPhotographer
        directShootBadge.isHidden = !photographer.isAbleToDirectShoot
        
        photographer.tags.forEach { tagStackView.addArrangedSubview(getTagBadge(title: $0)) }
    }
}

fileprivate final class SeparatorView: UICollectionReusableView {
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey2
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

