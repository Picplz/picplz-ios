//
//  OrderItemCell.swift
//  PicplzClient
//
//  Created by 임영택 on 4/8/25.
//

import UIKit

final class OrderItemCell: UICollectionViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    private let orderRules: [MapListOrderBy] = MapListOrderBy.allCases
    private var selectedRule = MapListOrderBy.distance
    private let textField = UITextField()
    private let pickerView = UIPickerView()
    private let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "DropDownSymbol")
        return imageView
    }()
    private var didSelectHandler: ((_ orderBy: MapListOrderBy) -> Void)?

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
        textField.textColor = .ppGrey5

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

    func configure(didSelectHandler: ((_ orderBy: MapListOrderBy) -> Void)?) {
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
