//
//  PhotographerReviewView.swift
//  PicplzClient
//
//  Created by 임영택 on 5/5/25.
//

import UIKit
import SnapKit

final class PhotographerReviewView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .smallTitle
        label.textColor = .picplzBlack
        label.text = "촬영 만족도"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .picplzWhite
        
        layout()
    }
    
    func layout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20) // TODO: 아래 컴포넌트들 쌓이면 삭제
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
