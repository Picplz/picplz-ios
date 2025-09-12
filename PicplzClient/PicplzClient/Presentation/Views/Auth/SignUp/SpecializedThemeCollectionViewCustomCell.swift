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
    weak var delegate: SpecializedThemeCollectionViewCustomCellDelegate?
    var editingTheme: Theme?
    var rightConstraint: NSLayoutConstraint?

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
        rightConstraint = contentView.rightAnchor.constraint(equalTo: editButton.rightAnchor, constant: 12)
        NSLayoutConstraint.activate([
            editButton.widthAnchor.constraint(equalToConstant: 12),
            editButton.heightAnchor.constraint(equalToConstant: 12),
            editButton.centerYAnchor.constraint(equalTo: titleTextField.centerYAnchor),
            editButton.leftAnchor.constraint(equalTo: titleTextField.rightAnchor, constant: 1),
            rightConstraint!
        ])
    }

    @objc private func editButtonTapped() {
        beginEditing()
    }

    private func handleEndEditing() {
        log.debug("SpecializedThemeCollectionViewCustomCell - handleEndEditing called")
        guard let theme = theme, let editingTheme = editingTheme else { return }
        titleTextField.isUserInteractionEnabled = false
        delegate?.didUpdateCustomThemeTitle(from: theme, to: editingTheme)

        self.theme = editingTheme
        self.editingTheme = nil
        editButton.isHidden = false
        rightConstraint?.constant = 12
    }

    @objc private func didChangeText() {
        if editingTheme == nil {
            editingTheme = theme
        }

        guard var theme = editingTheme,
              theme.setTitle(to: titleTextField.text ?? "") else { return }
        theme.initialized = true
        editingTheme = theme

        titleTextField.invalidateIntrinsicContentSize()
        if let collectionView = self.superview as? UICollectionView {
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    func beginEditing() {
        self.titleTextField.isUserInteractionEnabled = true
        self.titleTextField.becomeFirstResponder()
        self.updateStyle(to: true)
        editButton.isHidden = true
        rightConstraint?.constant = 0
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

protocol SpecializedThemeCollectionViewCustomCellDelegate: AnyObject {
    func didUpdateCustomThemeTitle(from previousTheme: Theme, to newTheme: Theme)
}
