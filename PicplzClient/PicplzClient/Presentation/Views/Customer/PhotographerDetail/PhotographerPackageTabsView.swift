//
//  PhotographerPackageTabsView.swift
//  PicplzClient
//
//  Created by 임영택 on 5/26/25.
//

import UIKit
import SnapKit

final class PhotographerPackageTabsView: UIView {
    let titleLabelView: UILabel = {
        let label = UILabel()
        label.text = "촬영 패키지"
        label.font = .smallTitle
        label.textColor = .picplzBlack
        return label
    }()
    let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    let tabsContentView = PhotographerPackageContentView()
    
    let packageInformations: [PhotographerPackage]
    
    var didSelectPackage: ((Int) -> Void)?
    
    init(packageInformations: [PhotographerPackage]) {
        self.packageInformations = packageInformations
        super.init(frame: .zero)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        packageInformations.enumerated().forEach { (index, package) in
            let tabView = PhotographerPackageTabItemView(packageName: package.packageName) { [weak self] in
                self?.didSelectPackage?(index)
            }
            headerStackView.addArrangedSubview(tabView)
        }
        
        addSubview(titleLabelView)
        addSubview(headerStackView)
        addSubview(tabsContentView)
        
        titleLabelView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        headerStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabelView.snp.bottom).offset(17)
            make.leading.trailing.equalToSuperview()
        }
        
        tabsContentView.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.bottom).offset(19)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        tabsContentView.configure(for: packageInformations.first)
    }
    
    func configure(selectedIndex: Int) {
        headerStackView.arrangedSubviews.enumerated().forEach { (index, packageItemView) in
            if let packageItemView = packageItemView as? PhotographerPackageTabItemView {
                packageItemView.setActive(isActive: selectedIndex == index)
            }
        }
        
        if packageInformations.indices.contains(selectedIndex) {
            tabsContentView.configure(for: packageInformations[selectedIndex])
        }
    }
}

final class PhotographerPackageTabItemView: UIView {
    let packageNameButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .caption
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        return button
    }()

    let separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .picplzBlack
        return separatorView
    }()
    
    let didTap: () -> Void
    
    init(packageName: String, didTap: @escaping () -> Void) {
        self.didTap = didTap
        super.init(frame: .zero)
        
        setLayout()
        packageNameButton.setTitle(packageName, for: .normal)
        packageNameButton.addTarget(self, action: #selector(didTapPackageNameButton), for: .touchUpInside)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        addSubview(packageNameButton)
        addSubview(separatorView)
        
        snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        packageNameButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
    }
    
    func setActive(isActive: Bool) {
        if isActive {
            packageNameButton.setTitleColor(.black, for: .normal)
            
            separatorView.backgroundColor = .picplzBlack
            separatorView.snp.updateConstraints { make in
                make.height.equalTo(2)
            }
        } else {
            packageNameButton.setTitleColor(.grey3, for: .normal)
            
            separatorView.backgroundColor = .grey2
            separatorView.snp.updateConstraints { make in
                make.height.equalTo(1)
            }
        }
    }
    
    @objc private func didTapPackageNameButton() {
        self.didTap()
    }
}
