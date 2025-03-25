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
    
    private let contentView: UIView = {
        let view = UILabel()
        view.text = "Hello, World!"
        view.backgroundColor = .picplzWhite
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttomSheetView = BottomSheetView(contentView: contentView)
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
}

struct BottomSheetExampleViewController_Preview: PreviewProvider {
    static var previews: some View {
        BottomSheetExampleViewController().toPreview()
    }
}
