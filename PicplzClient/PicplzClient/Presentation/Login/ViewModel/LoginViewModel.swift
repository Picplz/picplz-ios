//
//  LoginViewModel.swift
//  PicplzClient
//
//  Created by 임영택 on 2/9/25.
//

import Foundation
import Combine

final class LoginViewModel: LoginViewModelProtocol {
    weak var delegate: LoginViewModelDelegate?
    
    func loginFinished(resultUrl: URL) {
        let urlComponents = URLComponents(url: resultUrl, resolvingAgainstBaseURL: false)
        
        var accessToken: String?
        var expiresDate: String?
        
        if let queryItems = urlComponents?.queryItems {
            queryItems.forEach { item in
                if item.name == "accessToken" {
                    accessToken = item.value
                }
                
                if item.name == "expiresDate" {
                    expiresDate = item.value
                }
            }
        }
        
        print("accessToken=\(accessToken) expiresDate=\(expiresDate)")
        
        delegate?.loggedIn()
    }
}
