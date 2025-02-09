//
//  LoginViewModel.swift
//  PicplzClient
//
//  Created by 임영택 on 2/9/25.
//

import Combine

final class LoginViewModel: LoginViewModelProtocol {
    weak var delegate: LoginViewModelDelegate?
    
    func loginButtonTapped() {
        delegate?.loggedIn()
    }
}
