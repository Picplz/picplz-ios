//
//  ValidateNicknameUseCase.swift
//  Domain
//
//  Created by 임영택 on 3/2/26.
//

import Dependencies
import Foundation
import SwiftUI

public enum ProfileImageUploadUseCaseError: LocalizedError {
  case imageConversionFalied
  case picplzServerError(Error)
  case malformedUploadURL
  case awsError(Error)

  public var errorDescription: String? {
    switch self {
    case .imageConversionFalied: "이미지 직렬화에 실패했습니다"
    case .picplzServerError(let causeError):
      "픽플즈 서버 오류가 발생했습니다. 원인 오류: \(causeError.localizedDescription)"
    case .malformedUploadURL: "잘못된 업로드 URL입니다"
    case .awsError(let causeError):
      "AWS 서버 오류가 발생했습니다. 원인 오류: \(causeError.localizedDescription)"
    }
  }
}

public struct ProfileImageUploadUseCase {
  public var execute: (_ image: UIImage) async throws -> S3ObjectKey

  public static func live(s3Repository: any S3RepositoryProtocol) -> Self {
    let compressionQuality = CGFloat(0.8) // JPEG 압축률

    return Self { image in
      // Presigned URL 발급
      let (uploadURLString, objectKey): (S3PresignedURL, S3ObjectKey)
      do {
        (uploadURLString, objectKey) = try await s3Repository.getPresignedUploadURL(
          filename: "\(UUID().uuidString).jpg",
          fileType: .profile
        )
      } catch {
        throw ProfileImageUploadUseCaseError.picplzServerError(error)
      }

      // S3에 이미지 업로드
      guard let jpegData = image.jpegData(compressionQuality: compressionQuality) else {
        throw ProfileImageUploadUseCaseError.imageConversionFalied
      }
      guard let uploadURL = URL(string: uploadURLString) else {
        throw ProfileImageUploadUseCaseError.malformedUploadURL
      }

      do {
        try await s3Repository.uploadJPEGFile(jpegData: jpegData, to: uploadURL)
      } catch {
        throw ProfileImageUploadUseCaseError.awsError(error)
      }
      return objectKey
    }
  }

  public static var test: Self {
    Self { _ in "" }
  }
}

public enum ProfileImageUploadUseCaseKey: TestDependencyKey {
  public static var testValue: ProfileImageUploadUseCase = .test
}

extension DependencyValues {
  public var profileImageUploadUseCase: ProfileImageUploadUseCase {
    get { self[ProfileImageUploadUseCaseKey.self] }
    set { self[ProfileImageUploadUseCaseKey.self] = newValue }
  }
}
