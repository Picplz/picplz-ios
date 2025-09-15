//
//  MainViewModel.swift
//  PicplzClient
//
//  Created by 임영택 on 2/9/25.
//

import Combine

final class MainViewModel: MainViewModelProtocol {
    weak var delegate: MainViewModelDelegate?
    var userInfo: AuthUser?
    var getAuthInfoUseCase: GetAuthInfoUseCase?
    var logoutUseCase: LogoutUseCase?

    @Published var accessToken: String?
    var accessTokenPublisher: Published<String?>.Publisher {
        $accessToken
    }

    func viewPrepared() {
        accessToken = getAuthInfoUseCase?.getAccessToken()
        userInfo = getAuthInfoUseCase?.getUserInfo()
    }

    func logoutButtonTapped() {
        logoutUseCase?.logout()
        delegate?.loggedOut()
    }
}
