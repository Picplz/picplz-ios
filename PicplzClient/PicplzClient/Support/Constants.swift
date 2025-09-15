//
//  Constants.swift
//  PicplzClient
//
//  Created by 임영택 on 2/11/25.
//

import Foundation

struct Constants {
    static let serverBaseUrl: String = Bundle.main.infoDictionary?["Server Base URL"] as? String ?? "serverBaseUrl not set"
}
