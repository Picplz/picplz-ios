//
//  LoginViewModel.swift
//  PicplzClient
//
//  Created by 임영택 on 2/9/25.
//

import Combine

protocol LoginViewModelDelegate: AnyObject {
    func loggedIn()
}

final class LoginViewModel {
    weak var delegate: LoginViewModelDelegate?
    
    init(delegate: LoginViewModelDelegate) {
        self.delegate = delegate
    }
    
    func loginButtonTapped() {
        delegate?.loggedIn()
    }
}
