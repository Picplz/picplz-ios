//
//  PicLogger.swift
//  Common
//
//  Created by 임영택 on 2/26/26.
//

import Foundation
import OSLog

public final class PicLogger {
  private let subsystem: String
  private let category: String
  private let osLogger: Logger

  private let appenders: [LogAppending] = [
    LogFileAppender.shared,
    OSLogAppender.shared
  ]

  public init(category: String) {
    self.subsystem = Bundle.main.bundleIdentifier ?? "com.hm.picplz"
    self.category = category
    self.osLogger = Logger(subsystem: subsystem, category: category)
  }

  public func info(_ message: @autoclosure () -> String) {
    let message = message()
    log(level: .info, message: message)
  }

  public func debug(_ message: @autoclosure () -> String) {
    let message = message()
    #if DEBUG
    log(level: .debug, message: message)
    #endif
  }

  public func warning(_ message: @autoclosure () -> String) {
    let message = message()
    log(level: .warning, message: message)
  }

  public func error(_ message: @autoclosure () -> String) {
    let message = message()
    log(level: .error, message: message)
  }

  private func log(level: LogLevel, message: String) {
    appenders.forEach { appender in
      appender.write(category: category, message: message, level: level)
    }
  }
}
