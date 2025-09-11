//
//  CustomTabBar.swift
//  PicplzClient
//
//  Created by 임영택 on 9/2/25.
//

import UIKit

final class CustomTabBar: UIView {
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()

    var didSelectTab: (_ index: Int) -> Void = { _ in }

    private let horizontalPadding: CGFloat = 24
    private let verticalPadding: CGFloat = 15
    private let tabBarHeight: CGFloat = 84

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayout() {
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: horizontalPadding),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -horizontalPadding),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: verticalPadding),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -verticalPadding),
            self.heightAnchor.constraint(equalToConstant: self.tabBarHeight)
        ])
    }

    /// 탭바에 아이템을 추가
    func addArangedTabBarItem(_ item: UITabBarItem) {
        let view = CustomTabBarItemView(tabBarItem: item) { [weak self] index in
            self?.didSelectTab(index)
            self?.updateAppearance(selectedIndex: index)
        }
        stackView.addArrangedSubview(view)
    }

    /// 외부에서 특정 탭이 선택되었음을 알려줄 때 사용하는 메서드
    func selectTap(at index: Int) {
        updateAppearance(selectedIndex: index)
    }

    private func updateAppearance(selectedIndex: Int) {
        stackView.arrangedSubviews.forEach { view in
            if let view = view as? CustomTabBarItemView {
                view.isSelected = view.tabBarItem.tag == selectedIndex
            }
        }
    }
}
