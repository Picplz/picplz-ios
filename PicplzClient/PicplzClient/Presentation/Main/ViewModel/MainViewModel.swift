//
//  MainViewModel.swift
//  PicplzClient
//
//  Created by 임영택 on 2/9/25.
//

import Combine

final class MainViewModel: MainViewModelProtocol {
    weak var delegate: MainViewModelDelegate?
    
    func logoutButtonTapped() {
        delegate?.loggedOut()
    }
}
