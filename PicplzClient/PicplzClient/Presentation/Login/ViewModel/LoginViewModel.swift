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
    var loginUseCase: LoginUseCase?
    
    @Published var authEntrypointUrl: URL?
    var authEntrypointUrlPublisher: Published<URL?>.Publisher {
        $authEntrypointUrl
    }
    
    func loginFinished(resultUrl: URL) {
        let urlComponents = URLComponents(url: resultUrl, resolvingAgainstBaseURL: false)
        
        var accessToken: String?
        var expiresDateRaw: String?
        
        if let queryItems = urlComponents?.queryItems {
            queryItems.forEach { item in
                if item.name == "accessToken" {
                    accessToken = item.value
                }
                
                if item.name == "expiresDate" {
                    expiresDateRaw = item.value
                }
            }
        }
        
        if let accessToken = accessToken,
           let expiresDateRaw = expiresDateRaw,
           let expiresDate = parseExpiresDate(expiresDateRaw) {
            loginUseCase?.login(token: accessToken, expiresDate: expiresDate, user: AuthUser(name: "", nickname: "", birth: Date(), role: "", kakaoEmail: "", profileImageUrl: ""))
        }
        
        delegate?.loggedIn()
    }
    
    func didSetAuthProvider(authProvider: AuthProvider) {
        authEntrypointUrl = URL(string: "http://3.36.183.87:8080/api/v1\(authProvider.getAuthEntrypointPath())")
    }
    
    /**
    `Tue Feb 11 04:05:11 UTC 2025`
    형태의 스트링을 Date 객체로 변환
     */
    private func parseExpiresDate(_ rawDate: String) -> Date? {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        if let date = dateFormatter.date(from: rawDate) {
            return date
        }
        
        return nil
    }
}
