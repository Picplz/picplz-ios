//
//  SignUpPhotographerSpecializedThemesPageViewModelProtocol.swift
//  PicplzClient
//
//  Created by 임영택 on 2/25/25.
//

import Foundation

protocol SignUpPhotographerSpecializedThemesPageViewModelProtocol: SignUpVIewModelProtocol {
    var collectionViewItems: [ThemesSettingCollectionViewItem] { get }
    var collectionViewItemsPublisher: Published<[ThemesSettingCollectionViewItem]>.Publisher { get }

    func didSelectItem(indexPath: IndexPath)
    func customThemeUpdated(from previousTheme: Theme, to newTheme: Theme)

    func nextButtonDidTapped()
}

enum ThemesSettingCollectionViewSection {
    case main
}

enum ThemesSettingCollectionViewItem: Hashable {
    case content(theme: Theme, isSelected: Bool)
    case control
}
