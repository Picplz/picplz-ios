//
//  AFSessionFactory.swift
//  PicplzClient
//
//  Created by 임영택 on 8/5/25.
//

import Foundation
import Alamofire

struct AFSessionFactory {
    static func makeSession() -> Session {
        let logger = NetworkLogger()
        return Session(eventMonitors: [logger])
    }
}
