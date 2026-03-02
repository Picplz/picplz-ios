//
//  OSLogAppender.swift
//  Common
//
//  Created by 임영택 on 2/26/26.
//

import Foundation
import OSLog

final class OSLogAppender: LogAppending {
  /// 앱 전체에서 유일하게 사용될 싱글톤 인스턴스
  static let shared = OSLogAppender()

  /// 카테고리에 대한 로거 인스턴스 맵
  private var osLoggers: [String: Logger] = [:]

  /// Logger로부터 로그 데이터를 받아 파일에 씁니다.
  public func write(category: String, message: String, level: LogLevel) {
    if osLoggers[category] == nil {
      osLoggers[category] = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.hm.picplz.Common", category: category)
    }

    if let logger = osLoggers[category] {
      switch level {
      case .error: logger.error("\(message, privacy: .public)")
      case .warning: logger.warning("\(message, privacy: .public)")
      case .info: logger.info("\(message, privacy: .public)")
      case .debug: logger.debug("\(message, privacy: .public)")
      }
    }
  }
}
