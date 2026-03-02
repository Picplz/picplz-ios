//
//  LogAppending.swift
//  Common
//
//  Created by 임영택 on 2/26/26.
//

import Foundation

protocol LogAppending {
  func write(category: String, message: String, level: LogLevel)
}
