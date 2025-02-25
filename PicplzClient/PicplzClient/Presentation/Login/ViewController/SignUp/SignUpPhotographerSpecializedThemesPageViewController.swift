//
//  SignUpPhotographerSpecializedThemesPageViewController.swift
//  PicplzClient
//
//  Created by 임영택 on 2/24/25.
//

import UIKit
import Combine
import OSLog

final class SignUpPhotographerSpecializedThemesPageViewController: UIViewController {
//    var viewModel: SignUpPhotographerSpecializedThemesPageViewModel!
    private var subscriptions: Set<AnyCancellable> = []
    
    private let contentView = SignUpPhotographerSpecializedThemesSettingVIew()
    private let nextButton = UIPickplzButton()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private var itemList: [Item] = []
    
    private var log = Logger.of("SignUpPhotographerSpecializedThemesPageViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "감성 선택"
        
        setup()
        bind()
        
        registerCells(to: contentView.collectionView)
        initDataSource(to: contentView.collectionView)
        contentView.collectionView.collectionViewLayout = getLayout()
        contentView.collectionView.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didEditingEnd))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setup() {
        view.backgroundColor = .picplzWhite
        
        // MARK: ContentView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15.0),
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 15.0),
            contentView.heightAnchor.constraint(equalToConstant: 450),
        ])
        
        // MARK: Next Button
        nextButton.setTitle("다음", for: .normal)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(didNextButtonTapped), for: .touchUpInside)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            nextButton.heightAnchor.constraint(equalToConstant: 60),
            nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            view.rightAnchor.constraint(equalTo: nextButton.rightAnchor, constant: 15),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 47),
        ])
    }
    
    func bind() {
        
    }
    
    @objc private func didNextButtonTapped() {
//        viewModel.nextButtonDidTapped()
    }
    
    @objc private func didEditingEnd() {
        view.endEditing(true)
    }
}

extension SignUpPhotographerSpecializedThemesPageViewController {
    enum Section {
        case main
    }
    
    enum Item: Hashable {
        case content(theme: Theme, isSelected: Bool)
        case control
    }
    
    private func registerCells(to collectionView: UICollectionView) {
        collectionView.register(SpecializedThemeCollectionViewDefaultCell.self, forCellWithReuseIdentifier: "DefaultCell")
        collectionView.register(SpecializedThemeCollectionViewCustomCell.self, forCellWithReuseIdentifier: "CustomCell")
        collectionView.register(SpecializedThemeCollectionViewControlCell.self, forCellWithReuseIdentifier: "ControlCell")
    }
    
    private func initDataSource(to collectionView: UICollectionView) {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            let cell: UICollectionViewCell
            
            switch item {
            case .content(let theme, let isSelected):
                if !theme.userCreated {
                    guard let defaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath) as? SpecializedThemeCollectionViewDefaultCell else { return nil }
                    defaultCell.configuration(theme: theme, isSelected: isSelected)
                    cell = defaultCell
                } else {
                    guard let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as? SpecializedThemeCollectionViewCustomCell else { return nil }
                    customCell.configuration(theme: theme, isSelected: isSelected)
                    customCell.delegate = self
                    if !theme.initialized {
                        DispatchQueue.main.async {
                            customCell.beginEditing() // MARK: 레이아웃이 완료된 후 first responder로 만든다
                        }
                    }
                    
                    cell = customCell
                }
            case .control:
                guard let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ControlCell", for: indexPath) as? SpecializedThemeCollectionViewControlCell else { return nil }
                customCell.configuration(title: "+직접 적어주세요", isSelected: false)
                cell = customCell
            }
            
            return cell
        }
        
        applyDataSource(themes: Theme.predefinedThemes)
    }
    
    private func applyDataSource(themes: [Theme]) {
        let items = themes.map { Item.content(theme: $0, isSelected: false) } + [Item.control]
        applyDataSource(items: items)
    }
    
    private func applyDataSource(items: [Item]) {
        self.itemList = items
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        
        dataSource.apply(snapshot)
        
//        log.debug("snapshot applied - \(snapshot.itemIdentifiers)")
    }
    
    private func reloadItems() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(itemList, toSection: .main)
        
        dataSource.apply(snapshot)
    }
    
    private func replaceTheme(from previousTheme: Theme, to newTheme: Theme) {
        log.debug("replaceTheme called from=\(previousTheme.title) to=\(newTheme.title)")
        
        var newTheme: Theme? = newTheme
        
        let existingthemes: [Theme] = itemList
            .map { item in
                guard case .content(let theme, _) = item else {
                    return nil
                }
                
                return theme
            }
            .compactMap { $0 }
        
        // MARK: 이름이 중복인 경우
        if let themeToCompare = newTheme,
           existingthemes.contains(themeToCompare) {
            log.debug("이미 같은 이름의 감성이 추가되어 있어 제거합니다. \(themeToCompare.title)")
            newTheme = nil
        }
        
        let newItems: [Item] = itemList
            .map { item in
                if case let .content(theme, _) = item,
                   theme == previousTheme {
                    if let newTheme = newTheme {
                        return Item.content(theme: newTheme, isSelected: true)
                    }
                    return nil
                }
                return item
            }
            .compactMap { $0 } // newTheme이 nil인 경우 제거됨
        
        applyDataSource(items: newItems)
    }
    
    private func addCustomTheme() {
        let newTheme = Theme(title: "", userCreated: true, initialized: false)
        let newItem = Item.content(theme: newTheme, isSelected: false)
        
        let existingContentItems: [Item] = itemList
            .filter {
                if case .content = $0 {
                    return true
                } else {
                    return false
                }
            }
        
        let items = existingContentItems + [newItem, Item.control]
        self.itemList = items
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        
        dataSource.apply(snapshot)
    }
    
    private func getLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(72), heightDimension: .absolute(40))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(400))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension SignUpPhotographerSpecializedThemesPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.itemList[indexPath.row]
        if case let .content(theme, isSelected) = item {
            self.itemList[indexPath.row] = .content(theme: theme, isSelected: !isSelected)
            reloadItems()
        } else if case .control = item {
            log.debug("didSelectItemAt - .control")
            addCustomTheme()
        }
    }
}

extension SignUpPhotographerSpecializedThemesPageViewController: SpecializedThemeCollectionViewCustomCellDelegate {
    func didUpdateCustomThemeTitle(from previousTheme: Theme, to newTheme: Theme) {
        replaceTheme(from: previousTheme, to: newTheme)
    }
}
