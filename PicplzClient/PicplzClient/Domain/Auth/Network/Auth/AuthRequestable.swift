//
//  AuthRequestable.swift
//  PicplzClient
//
//  Created by 임영택 on 8/5/25.
//

import Foundation

protocol AuthRequestable {
    func kakaoLogin(kakaoAccessToken: String) async throws -> BaseResponse<KakaoLoginResponse>?
    func getUserInfo(accessToken: String, memberId: String) async throws -> BaseResponse<UserInfoResponse>?
}
