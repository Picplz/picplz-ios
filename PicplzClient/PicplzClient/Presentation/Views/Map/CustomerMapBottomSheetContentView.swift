//
//  CustomerMapBottomSheetContentView.swift
//  PicplzClient
//
//  Created by 임영택 on 3/23/25.
//

import UIKit

class CustomerMapBottomSheetContentView: UIView {
    let label: UILabel = {
        let label = UILabel()
        label.text = "Hello, World!"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .picplzWhite
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
