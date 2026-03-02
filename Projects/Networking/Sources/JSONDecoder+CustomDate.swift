//
//  JSONDecoder+CustomDate.swift
//  Networking
//
//  Created by 임영택 on 2/28/26.
//

import Foundation

extension JSONDecoder {
  static var customDateDecoder: JSONDecoder {
    let decoder = JSONDecoder()

    decoder.dateDecodingStrategy = .custom { decoder in
      let container = try decoder.singleValueContainer()
      let dateString = try container.decode(String.self)

      // 1. 나노초(9자리) 포함 형식 시도
      let nanoFormatter = DateFormatter()
      nanoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS"
      if let date = nanoFormatter.date(from: dateString) { return date }

      // 2. ISO8601 (밀리초 + 타임존) 형식 시도
      let isoFormatter = ISO8601DateFormatter()
      isoFormatter.formatOptions = [
        .withInternetDateTime, .withFractionalSeconds,
      ]
      if let date = isoFormatter.date(from: dateString) { return date }

      // 3. 일반 ISO8601 시도
      if let date = ISO8601DateFormatter().date(from: dateString) {
        return date
      }

      throw DecodingError.dataCorruptedError(
        in: container,
        debugDescription: "Invalid date: \(dateString)"
      )
    }
    return decoder
  }
}
