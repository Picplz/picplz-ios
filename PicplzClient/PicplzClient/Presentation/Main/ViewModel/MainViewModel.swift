//
//  MainViewModel.swift
//  PicplzClient
//
//  Created by 임영택 on 2/9/25.
//

import Combine

protocol MainViewModelDelegate: AnyObject {
    func loggedOut()
}

final class MainViewModel {
    weak var delegate: MainViewModelDelegate?
    
    init(delegate: MainViewModelDelegate) {
        self.delegate = delegate
    }
    
    func logoutButtonTapped() {
        delegate?.loggedOut()
    }
}
