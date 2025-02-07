//
//  Logger+Helpers.swift
//  PicplzClient
//
//  Created by 임영택 on 2/7/25.
//

import OSLog

extension Logger {
    static func of(_ category: String) -> Logger {
        let subsystem = Bundle.main.bundleIdentifier ?? "com.hm.picplz.PicplzClient"
        return Logger(subsystem: subsystem, category: category)
    }
}
