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
    private var dataSource: UICollectionViewDiffableDataSource<HeaderSection, MapListFilter>!
    
    private var photographerFilters: [MapListFilter] = MapListFilter.photographerFilters
    private var hashTagFilters: [MapListFilter] = MapListFilter.hashTagFilters
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .picplzWhite
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.collectionViewLayout = getLayout()
        collectionView.delegate = self
        
        collectionView.register(FilterItemCell.self, forCellWithReuseIdentifier: "FilterItemCell")
        
        dataSource = UICollectionViewDiffableDataSource<HeaderSection, MapListFilter>(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterItemCell", for: indexPath) as? FilterItemCell else {
                return nil
            }
            
            cell.configure(filter: item) { [weak self] filter in
                self?.didFilterButtonTapped(filter: filter)
            }
            
            return cell
        }
        
        applyDatasource()
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
                .offset(37 - topMargin)
            make.bottom.equalToSuperview()
            make.horizontalEdges
                .equalToSuperview()
                .offset(14)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(60), heightDimension: .absolute(25))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(1000), heightDimension: .estimated(25))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 11, trailing: 0)

        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func applyDatasource() {
        var snapshot = NSDiffableDataSourceSnapshot<HeaderSection, MapListFilter>()
        snapshot.appendSections([.photographerFilter])
        snapshot.appendItems(photographerFilters)
        snapshot.appendSections([.hashTagFilter])
        snapshot.appendItems(hashTagFilters)
        dataSource.apply(snapshot)
    }
    
    private func didFilterButtonTapped(filter: MapListFilter) {
        // TODO: Connect to viewModel
        // TODO: Make be selected only one
        print(filter)
    }
    
    enum HeaderSection {
        case photographerFilter
        case hashTagFilter
    }
}

extension CustomerMapBottomSheetContentView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

fileprivate final class FilterItemCell: UICollectionViewCell {
    private var filter: MapListFilter?
    private(set) var button: UIButton?
    private var didTapButtonHandler: ((_ filter: MapListFilter) -> Void)?
    
    override func prepareForReuse() {
        self.button?.removeFromSuperview()
        self.button = nil
    }
    
    func configure(filter: MapListFilter, didTapButtonHandler: ((_ filter: MapListFilter) -> Void)?) {
        self.button?.removeFromSuperview()
        
        if filter.type == .photographerFilter {
            self.button = UIPicplzButton3(title: filter.filterTitle, image: filter.image!)
        } else {
            self.button = UIPicplzButton4(title: filter.filterTitle)
            self.button?.setTitle(filter.filterTitle, for: .normal)
        }
        self.button?.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        layoutButton()
        
        self.filter = filter
        
        self.didTapButtonHandler = didTapButtonHandler
    }
    
    @objc func didTapButton() {
        guard let filter = self.filter else { return }
        didTapButtonHandler?(filter)
    }
    
    func layoutButton() {
        guard let button = button else { return }
        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}

struct MapListFilter: Hashable {
    let filterTitle: String
    let image: UIImage?
    let type: FilterType
    var isSelected: Bool
    
    static var photographerFilters: [MapListFilter] = [
        .init(filterTitle: "팔로우", image: UIImage(named: "CheckSymbol"), type: .photographerFilter, isSelected: false),
        .init(filterTitle: "바로 촬영 가능", image: UIImage(named: "CameraSymbol"), type: .photographerFilter, isSelected: false),
    ]
    
    static var hashTagFilters: [MapListFilter] = [
        .init(filterTitle: "#을지로 감성", image: nil, type: .hashTagFilter, isSelected: false),
        .init(filterTitle: "#키치 감성", image: nil, type: .hashTagFilter, isSelected: false),
        .init(filterTitle: "#MZ 감성", image: nil, type: .hashTagFilter, isSelected: false),
        .init(filterTitle: "#퇴폐 감성", image: nil, type: .hashTagFilter, isSelected: false),
        .init(filterTitle: "#퇴폐 감성2", image: nil, type: .hashTagFilter, isSelected: false),
        .init(filterTitle: "#퇴폐 감성3", image: nil, type: .hashTagFilter, isSelected: false),
        .init(filterTitle: "#퇴폐 감성4", image: nil, type: .hashTagFilter, isSelected: false),
        .init(filterTitle: "#퇴폐 감성5", image: nil, type: .hashTagFilter, isSelected: false),
    ]
    
    enum FilterType {
        case photographerFilter
        case hashTagFilter
    }
}

//struct CustomerMapViewController_Preview2: PreviewProvider {
//    static var previews: some View {
//        let vc = CustomerMapViewController()
//        vc.viewModel = CustomerMapViewModel(
//            getShortAddressUseCase: GetShortAddressUserCaseImpl(locationService: LocationServiceImpl())
//        )
//        
//        return vc.toPreview()
//            .ignoresSafeArea()
//    }
//}
