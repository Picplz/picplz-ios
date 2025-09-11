//
//  AuthApi.swift
//  PicplzClient
//
//  Created by 임영택 on 5/13/25.
//

import Alamofire
import Foundation

final class AuthRequests: AuthRequestable {
    private let jsonDecoder: JSONDecoder = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX" // .iso8601로 지원하지 않는 형식

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()

    func kakaoLogin(kakaoAccessToken: String) async throws -> BaseResponse<KakaoLoginResponse>? {
        let session = AFSessionFactory.makeSession()
        let response = await session.request(
            "\(Constants.serverBaseUrl)/auth/kakao",
            method: .post,
            parameters: KakaoLoginRequest(accessToken: kakaoAccessToken),
            encoder: JSONParameterEncoder.default
        )
            .validate()
            .serializingDecodable(BaseResponse<KakaoLoginResponse>.self, decoder: jsonDecoder)
            .response
        return response.value
    }

    func getUserInfo(accessToken: String, memberId: String) async throws -> BaseResponse<UserInfoResponse>? {
        let session = AFSessionFactory.makeSession()
        let response = await session.request(
            "\(Constants.serverBaseUrl)/members/\(memberId)/info",
            headers: .init(dictionaryLiteral: ("Authorization", "Bearer \(accessToken)"))
        )
            .validate()
            .serializingDecodable(BaseResponse<UserInfoResponse>.self, decoder: jsonDecoder)
            .response
        return response.value
    }
}
