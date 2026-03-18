//
//  S3RepositoryProtocol.swift
//  Domain
//
//  Created by 임영택 on 3/10/26.
//

import Foundation
import Dependencies

public typealias S3PresignedURL = String
public typealias S3ObjectKey = String

public enum S3FileType {
  case profile
  case portfolio
  
  public var serverCode: String {
    switch self {
    case .profile: "PROFILE"
    case .portfolio: "PORTFOLIO"
    }
  }
}

public protocol S3RepositoryProtocol {
  func getPresignedUploadURL(filename: String, fileType: S3FileType) async throws -> (S3PresignedURL, S3ObjectKey)
  func uploadJPEGFile(jpegData: Data, to presignedURL: URL) async throws
}

struct UnimplementedS3Repository: S3RepositoryProtocol {
  func getPresignedUploadURL(filename: String, fileType: S3FileType) async throws -> (S3PresignedURL, S3ObjectKey) {
    fatalError("구현되지 않은 메서드를 호출했습니다")
  }
  
  func uploadJPEGFile(jpegData: Data, to presignedURL: URL) async throws {
    fatalError("구현되지 않은 메서드를 호출했습니다")
  }
}

public enum S3RepositoryKey: TestDependencyKey {
  public static var testValue: S3RepositoryProtocol = UnimplementedS3Repository()
}

public extension DependencyValues {
  var s3Repository: S3RepositoryProtocol {
    get { self[S3RepositoryKey.self] }
    set { self[S3RepositoryKey.self] = newValue }
  }
}
