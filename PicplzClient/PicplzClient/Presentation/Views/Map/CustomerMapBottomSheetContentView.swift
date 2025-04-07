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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .picplzWhite
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.collectionViewLayout = getLayout()
        
        collectionView.register(FilterItemCell.self, forCellWithReuseIdentifier: "FilterItemCell")
        collectionView.register(OrderItemCell.self, forCellWithReuseIdentifier: "OrderItemCell")
        
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
            default:
                return nil
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
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.photographerFilter, .hashTagFilter, .orderControl])
        snapshot.appendItems(photographerFilters.map({ Item.filter($0) }), toSection: .photographerFilter)
        snapshot.appendItems(hashTagFilters.map({ Item.filter($0) }), toSection: .hashTagFilter)
        snapshot.appendItems([.order], toSection: .orderControl)
        dataSource.apply(snapshot)
    }
    
    private func didFilterButtonTapped(filter: MapListFilter) {
        // TODO: Connect to viewModel
        // TODO: Make be selected only one
        print(filter)
    }
    
    private func didOrderBySelected(order: OrderBy) {
        // TODO: Connect to viewModel
        print(order)
    }
}

fileprivate enum Section {
    case photographerFilter
    case hashTagFilter
    case orderControl
}

fileprivate enum Item: Hashable {
    case filter(MapListFilter)
    case order
    case photographerList
}

// FIXME: separate file
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

// FIXME: separate file
fileprivate final class OrderItemCell: UICollectionViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    private let orderRules: [OrderBy] = OrderBy.allCases
    private var selectedRule = OrderBy.distance
    private let textField = UITextField()
    private let pickerView = UIPickerView()
    private let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "DropDownSymbol")
        return imageView
    }()
    private var didSelectHandler: ((_ orderBy: OrderBy) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // MARK: set pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // MARK: set pickerView as textField's inputView
        textField.inputView = pickerView
        textField.tintColor = .clear // 커서 숨기기
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        textField.text = selectedRule.title
        textField.font = UIFont.caption
        textField.textColor = .grey5
        
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading)
            make.verticalEdges.equalTo(self)
        }
        
        addSubview(symbolImageView)
        symbolImageView.snp.makeConstraints { make in
            make.leading.equalTo(textField.snp.trailing).offset(4)
            make.trailing.equalTo(self.snp.trailing)
            make.centerY.equalTo(textField.snp.centerY)
        }
    }
    
    func configure(didSelectHandler: ((_ orderBy: OrderBy) -> Void)?) {
        self.didSelectHandler = didSelectHandler
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        orderRules.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        orderRules[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerViewSelected()
    }
    
    private func pickerViewSelected() {
        let row = pickerView.selectedRow(inComponent: 0)
        selectedRule = orderRules[row]
        textField.text = selectedRule.title
        textField.resignFirstResponder()
        
        didSelectHandler?(selectedRule)
    }
    
    @objc private func cellTapped() {
        textField.becomeFirstResponder()
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

fileprivate enum OrderBy: CaseIterable {
    case distance
    case popularity
    
    var title: String {
        switch self {
        case .distance:
            return "거리순"
        case .popularity:
            return "인기순"
        }
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
