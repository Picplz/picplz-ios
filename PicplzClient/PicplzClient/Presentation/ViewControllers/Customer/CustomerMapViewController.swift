//
//  CustomerMapViewController.swift
//  PicplzClient
//
//  Created by 임영택 on 3/12/25.
//

import UIKit
import SwiftUI

class CustomerMapViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let mapView = MapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .grey1
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        
        mapView.backgroundColor = .clear
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        scrollView.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // adjust offset on next roop
        DispatchQueue.main.async {
            let scrollViewSize = self.scrollView.bounds.size
            let contentSize = self.scrollView.contentSize
            
            guard contentSize.width > 0 else { return }
            
            let offsetX = (contentSize.width - scrollViewSize.width) / 2
            let offsetY = (contentSize.height - scrollViewSize.height) / 2
            
            self.scrollView.setContentOffset(CGPoint(x: offsetX, y: offsetY), animated: false)
        }
    }
}

extension CustomerMapViewController: UIScrollViewDelegate {
}

struct CustomerMapViewController_Preview: PreviewProvider {
    static var previews: some View {
        CustomerMapViewController().toPreview()
    }
}
