//
//  Tokens.swift
//  PicplzClient
//
//  Created by 임영택 on 8/5/25.
//

import Foundation
import os.log

struct Tokens {
    let accessToken: String
    let refreshToken: String
    let expiresDate: Date
}

extension Tokens {
    var logger: Logger { Logger.of("Tokens") }
    
    var accessTokenPayload: AccessTokenPayload? {
        if accessToken.split(separator: ".").count != 3 {
            logger.error("Access Token이 잘못되었습니다.")
            return nil
        }
        
        let accessTokenPayloadRaw = String(accessToken.split(separator: ".")[1])
        let accessTokenPayload = Data(base64Encoded: accessTokenPayloadRaw)
        
        guard let accessTokenPayload else {
            logger.error("Access Token BASE64 스트링을 파싱하지 못했습니다.")
            return nil
        }
        
        let jsonDecoder = JSONDecoder()
        do {
            let decoded = try jsonDecoder.decode(AccessTokenPayload.self, from: accessTokenPayload)
            return decoded
        } catch {
            logger.error("Access Token을 디코딩하지 못했습니다. error: \(error)")
            return nil
        }
    }
    
    struct AccessTokenPayload: Decodable {
        let sub: String
        let auth: String
        let exp: Int
    }
}
