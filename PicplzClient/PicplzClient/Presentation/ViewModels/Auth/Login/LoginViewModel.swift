//
//  LoginViewModel.swift
//  PicplzClient
//
//  Created by 임영택 on 2/9/25.
//

import Foundation
import Combine
import OSLog

final class LoginViewModel: LoginViewModelProtocol {
    weak var delegate: LoginViewModelDelegate?
    var loginUseCase: LoginUseCase?
    
    @Published var authEntrypointUrl: URL?
    var authEntrypointUrlPublisher: Published<URL?>.Publisher {
        $authEntrypointUrl
    }
    
    private var log = Logger.of("LoginViewModel")
    
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
            delegate?.loggedIn()
        } else {
            log.error("failed to parse accessToken or(and) expiresDate... accessToken=\(String(describing: accessToken)) expiresDateRaw=\(String(describing: expiresDateRaw))")
            // TODO: Inform to user to failed to login...
        }
    }
    
    func didSetAuthProvider(authProvider: AuthProvider) {
        authEntrypointUrl = URL(string: "\(Constants.serverBaseUrl)\(authProvider.getAuthEntrypointPath())")
        print("-> \(Constants.serverBaseUrl)\(authProvider.getAuthEntrypointPath())")
    }
    
    /**
    `Tue Feb 11 04:05:11 UTC 2025`
    형태의 스트링을 Date 객체로 변환
     */
    private func parseExpiresDate(_ rawDate: String) -> Date? {
        let dateFormatter = DateFormatter()

        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss 'UTC' yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        if let date = dateFormatter.date(from: rawDate) {
            return date
        }
        
        return nil
    }
}
