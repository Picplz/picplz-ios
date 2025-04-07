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
    private var photographerList: [MapListPhotographer] = MapListPhotographer.debugList
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .picplzWhite
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
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
            default: // 그 외
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(60), heightDimension: .absolute(25))
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
        print(filter)
    }
    
    private func didOrderBySelected(order: OrderBy) {
        // TODO: Connect to viewModel
        print(order)
    }
    
    private func didPhotographerSelected(photographer: MapListPhotographer) {
        // TODO: Connect to viewModel
        print(photographer)
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
    case photographerList(MapListPhotographer)
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
    
    private var photographer: MapListPhotographer?
    private var didSelectHandler: ((_ orderBy: MapListPhotographer) -> Void)?
    
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
    
    func configure(photographer: MapListPhotographer, didSelectHandler: ((_ photographer: MapListPhotographer) -> Void)?) {
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
        .init(filterTitle: "#어떤 감성2", image: nil, type: .hashTagFilter, isSelected: false),
        .init(filterTitle: "#어떤 감성3", image: nil, type: .hashTagFilter, isSelected: false),
        .init(filterTitle: "#어떤 감성4", image: nil, type: .hashTagFilter, isSelected: false),
        .init(filterTitle: "#어떤 감성5", image: nil, type: .hashTagFilter, isSelected: false),
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

struct MapListPhotographer: Hashable {
    // FIXME: ID 포함
    let name: String
    let distanceIntMeters: Int
    let walkTimeInMinutes: Int
    let isOurTownPhotographer: Bool
    let isAbleToDirectShoot: Bool
    let image: UIImage?
    let tags: [String] // FIXME: hastag 별도 타입 참조
    
    // FIXME: just for debug. remove after implementing commuincate with backend
    static let debugList: [MapListPhotographer] = [
        .init(
            name: "유가영",
            distanceIntMeters: 200,
            walkTimeInMinutes: 3,
            isOurTownPhotographer: true,
            isAbleToDirectShoot: true,
            image: nil,
            tags: ["#을지로 감성", "#MZ 감성", "#퇴폐 감성",  "#어떤 감성"]
        ),
        .init(
            name: "주은강",
            distanceIntMeters: 200,
            walkTimeInMinutes: 3,
            isOurTownPhotographer: true,
            isAbleToDirectShoot: false,
            image: nil,
            tags: ["#을지로 감성"]
        ),
        .init(
            name: "임세연",
            distanceIntMeters: 200,
            walkTimeInMinutes: 3,
            isOurTownPhotographer: false,
            isAbleToDirectShoot: true,
            image: nil,
            tags: ["#을지로 감성"]
        ),
        .init(
            name: "짱구",
            distanceIntMeters: 200,
            walkTimeInMinutes: 3,
            isOurTownPhotographer: false,
            isAbleToDirectShoot: true,
            image: nil,
            tags: ["#을지로 감성"]
        ),
    ]
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
