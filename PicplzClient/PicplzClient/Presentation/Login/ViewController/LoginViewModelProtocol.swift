//
//  LoginViewModelProtocol.swift
//  PicplzClient
//
//  Created by 임영택 on 2/9/25.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func loggedIn()
}

protocol LoginViewModelProtocol {
    var delegate: LoginViewModelDelegate? { get set }
    var loginUseCase: LoginUseCase? { get set }
    
    var authEntrypointUrl: URL? { get }
    var authEntrypointUrlPublisher: Published<URL?>.Publisher { get }
    
    func loginFinished(resultUrl: URL)
    func didSetAuthProvider(authProvider: AuthProvider)
}
