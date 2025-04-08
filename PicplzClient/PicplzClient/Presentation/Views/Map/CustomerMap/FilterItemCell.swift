//
//  FilterItemCell.swift
//  PicplzClient
//
//  Created by 임영택 on 4/8/25.
//

import UIKit

final class FilterItemCell: UICollectionViewCell {
    private var filter: MapListFilter?
    private(set) var button: UIButton?
    private var didTapButtonHandler: ((_ filter: MapListFilter) -> Void)?
    
    override func prepareForReuse() {
        self.button?.removeFromSuperview()
        self.button = nil
    }
    
    func configure(filter: MapListFilter, didTapButtonHandler: ((_ filter: MapListFilter) -> Void)?) {
        self.didTapButtonHandler = didTapButtonHandler
        self.filter = filter
        
        if filter.type == .photographerFilter {
            button = UIPicplzButton3(title: filter.filterTitle, image: filter.image!)
        } else {
            button = UIPicplzButton4(title: filter.filterTitle)
        }
        button?.isSelected = filter.isSelected
        layoutButton()
        
        button?.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc func didTapButton() {
        guard let filter = self.filter else { return }
        didTapButtonHandler?(filter)
    }
    
    func layoutButton() {
        guard let button = button else { return }
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        button.invalidateIntrinsicContentSize()
        setNeedsLayout()
        layoutIfNeeded()
    }
}
