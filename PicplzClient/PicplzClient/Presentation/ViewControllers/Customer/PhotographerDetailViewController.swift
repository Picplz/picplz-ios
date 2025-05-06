//
//  PhotographerDetailViewController.swift
//  PicplzClient
//
//  Created by 임영택 on 4/20/25.
//

import UIKit
import SnapKit
import Combine

class PhotographerDetailViewController: UIViewController {
    private let infoView = PhotographerInfoView()
    
    var viewModel: PhotographerDetailViewModel!
    
    private var subscriptions: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(infoView)
        
        infoView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        bind()
    }
    
    private func bind() {
        viewModel.photographerIdPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] id in
                // FIXME: filter DEBUG DATA
                let filteredPhotographers = PhotographerDetail.debugList.filter { $0.id == id }
                if let selectedPhotographer = filteredPhotographers.first {
                    self?.infoView.configure(photographer: selectedPhotographer)
                }
            }
            .store(in: &subscriptions)
    }
}

import SwiftUI
struct PhotographerDetailViewController_Preview: PreviewProvider {
    static var previews: some View {
        let vc = PhotographerDetailViewController()
        let vm = PhotographerDetailViewModel()
        vc.viewModel = vm
        vm.photographerId = 1
        
        return vc.toPreview()
            .ignoresSafeArea()
    }
}
