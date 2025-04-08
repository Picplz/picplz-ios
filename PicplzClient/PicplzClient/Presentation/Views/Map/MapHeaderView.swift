//
//  MapHeaderView.swift
//  PicplzClient
//
//  Created by 임영택 on 3/12/25.
//

import UIKit

class MapHeaderView: UIView {
    let locationMarkerView = UIImageView(image: UIImage(named: "LocationMarker"))
    let addressLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        locationMarkerView.translatesAutoresizingMaskIntoConstraints = false
        
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.textColor = .picplzBlack
        addressLabel.font = .middleTitleSemiBold
        
        addSubview(locationMarkerView)
        addSubview(addressLabel)
        
        NSLayoutConstraint.activate([
            locationMarkerView.topAnchor.constraint(equalTo: topAnchor),
            locationMarkerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            locationMarkerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            locationMarkerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            addressLabel.leadingAnchor.constraint(equalTo: locationMarkerView.trailingAnchor, constant: 4.67),
            addressLabel.centerYAnchor.constraint(equalTo: locationMarkerView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
