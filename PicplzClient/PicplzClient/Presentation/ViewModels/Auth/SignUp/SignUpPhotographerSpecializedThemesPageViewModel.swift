//
//  SignUpPhotographerSpecializedThemesPageViewModel.swift
//  PicplzClient
//
//  Created by 임영택 on 2/25/25.
//

import Combine
import OSLog

final class SignUpPhotographerSpecializedThemesPageViewModel: SignUpPhotographerThemesPageViewModelProtocol {
    typealias Item = ThemesSettingCollectionViewItem

    weak var delegate: SignUpViewModelDelegate?
    var currentPage: Int = 0
    var signUpSession: SignUpSession?

    @Published private(set) var nextButtonEnabled: Bool = true
    var nextButtonEnabledPublisher: Published<Bool>.Publisher {
        $nextButtonEnabled
    }

    @Published private(set) var collectionViewItems: [ThemesSettingCollectionViewItem] = {
        let predefinedThemes = Theme.predefinedThemes
        return predefinedThemes.map { Item.content(theme: $0, isSelected: false) } + [Item.control]
    }() {
        didSet {
            updateSignUpSession(with: collectionViewItems)
        }
    }
    var collectionViewItemsPublisher: Published<[ThemesSettingCollectionViewItem]>.Publisher {
        $collectionViewItems
    }

    private var log = Logger.of("SignUpPhotographerSpecializedThemesPageViewModel")

    private func replaceTheme(from previousTheme: Theme, to newTheme: Theme) {
        log.debug("replaceTheme called from=\(previousTheme.title) to=\(newTheme.title)")

        var newTheme: Theme? = newTheme

        let existingthemes: [Theme] = collectionViewItems
            .compactMap { item in
                guard case .content(let theme, _) = item else {
                    return nil
                }

                return theme
            }

        // MARK: 이름이 중복인 경우
        if let themeToCompare = newTheme,
           existingthemes.contains(themeToCompare) {
            log.debug("이미 같은 이름의 감성이 추가되어 있어 제거합니다. \(themeToCompare.title)")
            newTheme = nil
        }

        let newItems: [Item] = collectionViewItems
            .compactMap { item in
                if case let .content(theme, _) = item,
                   theme == previousTheme {
                    if let newTheme = newTheme {
                        return Item.content(theme: newTheme, isSelected: true)
                    }
                    return nil
                }
                return item
            } // newTheme이 nil인 경우 제거됨

        collectionViewItems = newItems
    }

    func didSelectItem(indexPath: IndexPath) {
        let item = collectionViewItems[indexPath.row]
        if case let .content(theme, isSelected) = item {
            collectionViewItems[indexPath.row] = .content(theme: theme, isSelected: !isSelected)
        } else if case .control = item {
            didTapNewThemeButton()
        }
    }

    private func didTapNewThemeButton() {
        let newTheme = Theme(title: "", userCreated: true, initialized: false)
        let newItem = Item.content(theme: newTheme, isSelected: false)

        let existingContentItems: [Item] = collectionViewItems
            .filter {
                if case .content = $0 {
                    return true
                } else {
                    return false
                }
            }

        let items = existingContentItems + [newItem, Item.control]
        collectionViewItems = items
    }

    func customThemeUpdated(from previousTheme: Theme, to newTheme: Theme) {
        replaceTheme(from: previousTheme, to: newTheme)
    }

    func nextButtonDidTapped() {
        delegate?.goToNextPage(current: currentPage, session: signUpSession)
    }

    private func updateSignUpSession(with collectionViewItems: [Item]) {
        let selectedThemes: [Theme] = collectionViewItems
            .compactMap { item in
                if case let .content(theme, isSelected) = item,
                   isSelected {
                    return theme
                }
                return nil
            }

        signUpSession?.photoSpecializedThemes = selectedThemes.map { $0.title }
    }
}
