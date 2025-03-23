//
//  CustomerMapBottomSheetView.swift
//  PicplzClient
//
//  Created by 임영택 on 3/23/25.
//

import UIKit

class CustomerMapBottomSheetView: UIView {
    let handle: UIView = {
        let handle = UIView()
        
        let square = UIView()
        square.backgroundColor = .picplzBlack
        square.layer.cornerRadius = 1
        
        handle.translatesAutoresizingMaskIntoConstraints = false
        square.translatesAutoresizingMaskIntoConstraints = false
        handle.addSubview(square)
        
        NSLayoutConstraint.activate([
            square.widthAnchor.constraint(equalToConstant: 20),
            square.heightAnchor.constraint(equalToConstant: 2),
            square.centerXAnchor.constraint(equalTo: handle.centerXAnchor),
            square.centerYAnchor.constraint(equalTo: handle.centerYAnchor),
        ])
        
        handle.backgroundColor = .picplzWhite
        return handle
    }()
    let label: UILabel = {
        let label = UILabel()
        label.text = "Hello, World!"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .picplzWhite
        
        handle.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(handle)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            handle.heightAnchor.constraint(equalToConstant: 10),
            handle.widthAnchor.constraint(equalToConstant: 100),
            handle.centerXAnchor.constraint(equalTo: centerXAnchor),
            handle.centerYAnchor.constraint(equalTo: topAnchor, constant: 8),
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
