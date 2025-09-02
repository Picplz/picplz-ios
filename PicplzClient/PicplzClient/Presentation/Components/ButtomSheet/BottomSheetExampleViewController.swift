//
//  BottomSheetExampleViewController.swift
//  PicplzClient
//
//  Created by 임영택 on 3/24/25.
//

import UIKit
import SwiftUI

class BottomSheetExampleViewController: UIViewController {
    private var buttomSheetView: BottomSheetView!
    
    private let maxYMargin: CGFloat = 24
    
    private let contentView: UIView = {
        let view = UILabel()
        view.text = "Hello, World!"
        view.backgroundColor = .ppWhite
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let safeFrame = view.safeAreaLayoutGuide.layoutFrame
        buttomSheetView = BottomSheetView(contentView: contentView, prefereces: .getBasicPreferences(maxYOffset: safeFrame.minY + maxYMargin, minYOffset: safeFrame.maxY))
        buttomSheetView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buttomSheetView)
        NSLayoutConstraint.activate([
            buttomSheetView.topAnchor.constraint(equalTo: view.topAnchor),
            buttomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        view.bringSubviewToFront(buttomSheetView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // MARK: 오토레이아웃 이후 진행해야 safeAreaLayoutGuide의 정확한 프레임을 알 수 있다
        let safeFrame = view.safeAreaLayoutGuide.layoutFrame
        buttomSheetView.minYOffset = safeFrame.maxY
        buttomSheetView.maxYOffset = safeFrame.minY + maxYMargin // 여유를 둔다
    }
}

struct BottomSheetExampleViewController_Preview: PreviewProvider {
    static var previews: some View {
        BottomSheetExampleViewController().toPreview()
    }
}
