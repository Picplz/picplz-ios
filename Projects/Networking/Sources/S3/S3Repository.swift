//
//  S3Repository.swift
//  Networking
//
//  Created by 임영택 on 2/27/26.
//

import Dependencies
import Domain
import Foundation
import Moya
import Common

public final class S3Repository: S3RepositoryProtocol {
  private let provider: MoyaProvider<PicplzS3Api>

  public init(provider: MoyaProvider<PicplzS3Api> = .init()) {
    self.provider = provider
  }

  public func getPresignedUploadURL(filename: String, fileType: S3FileType)
    async throws -> (S3PresignedURL, S3ObjectKey)
  {
    let dto: GetPresignedUploadURLResponsedDTO = try await provider.requestWithDTO(
      .getPresignedUploadURL(
        fileType: fileType.serverCode,
        fileName: filename
      )
    )

    return (dto.uploadUrl, dto.objectKey)
  }

  public func uploadJPEGFile(jpegData: Data, to presignedURL: URL) async throws {
    var request = URLRequest(url: presignedURL)
    request.httpMethod = "PUT"

    request.setValue(
      "image/jpeg",
      forHTTPHeaderField: "Content-Type"
    )

    let (data, response) = try await URLSession.shared.upload(
      for: request,
      from: jpegData
    )

    guard let httpResponse = response as? HTTPURLResponse else {
      logger.error("S3 업로드 실패. Bad Server Response.")
      throw URLError(.badServerResponse)
    }

    guard (200...299).contains(httpResponse.statusCode) else {
      if let errorBody = String(data: data, encoding: .utf8) {
        logger.error("S3 업로드 실패. Status Code: \(httpResponse.statusCode) Response Body: \(errorBody)")
      } else {
        logger.error("S3 업로드 실패. Status Code: \(httpResponse.statusCode)")
      }
      throw URLError(.init(rawValue: httpResponse.statusCode))
    }
  }
  
  private let logger = PicLogger(category: "S3Repository")
}
