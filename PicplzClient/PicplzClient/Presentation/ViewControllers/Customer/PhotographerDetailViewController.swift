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
    private let scrollView = UIScrollView()
    private let scrollContentView = UIView()
    private let infoView = PhotographerInfoView()
    private let dividerView = DividerView(backgroundColor: .grey1)
    private let reviewView = PhotographerReviewDigestView()
    
    var viewModel: PhotographerDetailViewModel!
    
    private var subscriptions: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        
        scrollContentView.addSubview(infoView)
        scrollContentView.addSubview(dividerView)
        scrollContentView.addSubview(reviewView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollContentView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.width.height.top.bottom.equalTo(scrollView)
        }
        
        infoView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.top.equalToSuperview()
        }
        
        dividerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(infoView.snp.bottom)
            make.height.equalTo(10)
        }
        
        reviewView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.top.equalTo(dividerView.snp.bottom).offset(10)
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
                    self?.reviewView.configure(reviews: filteredPhotographers.first?.reviews ?? [])
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
