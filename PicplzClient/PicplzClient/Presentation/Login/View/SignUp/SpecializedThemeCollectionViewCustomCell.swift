//
//  SpecializedThemeCollectionViewCustomCell.swift
//  PicplzClient
//
//  Created by 임영택 on 2/24/25.
//

import UIKit
import OSLog

/**
 사용자가 정의한 감성 항목을 표시하는 셀
 */
final class SpecializedThemeCollectionViewCustomCell: SpecializedThemeCollectionViewDefaultCell {
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "PencilIcon"), for: .normal)
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var log = Logger.of("SpecializedThemeCollectionViewCustomCell")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleTextField.delegate = self
        titleTextField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func style() {
        super.style()
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layout() {
        super.layout()
        
        contentView.addSubview(editButton)
        NSLayoutConstraint.activate([
            editButton.widthAnchor.constraint(equalToConstant: 12),
            editButton.heightAnchor.constraint(equalToConstant: 12),
            editButton.centerYAnchor.constraint(equalTo: titleTextField.centerYAnchor),
            editButton.leftAnchor.constraint(equalTo: titleTextField.rightAnchor, constant: 1),
            contentView.rightAnchor.constraint(equalTo: editButton.rightAnchor, constant: 12),
        ])
    }
    
    @objc private func editButtonTapped() {
        titleTextField.isUserInteractionEnabled = true
        titleTextField.becomeFirstResponder()
        updateStyle(to: true)
    }

    private func handleEndEditing() {
        log.debug("SpecializedThemeCollectionViewCustomCell handleEndEditing called")
        titleTextField.isUserInteractionEnabled = false
    }
    
    @objc private func didChangeText() {
        titleTextField.invalidateIntrinsicContentSize()
        if let collectionView = self.superview as? UICollectionView {
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
}

extension SpecializedThemeCollectionViewCustomCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleEndEditing()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        handleEndEditing()
    }
}
