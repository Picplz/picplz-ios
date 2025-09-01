//
//  CustomerRequests.swift
//  PicplzClient
//
//  Created by 임영택 on 8/5/25.
//

import Foundation
import Alamofire

final class CustomerRequests: CustomerRequestable {
    func create(registerDto: CustomerRegisterDTO) async throws {
        let session = AFSessionFactory.makeSession()
        let _ = try await session.request(
            "\(Constants.serverBaseUrl)/customers",
            method: .post,
            parameters: registerDto,
            encoder: JSONParameterEncoder.default
        )
            .validate()
            .serializingData()
            .value
    }
}
