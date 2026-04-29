//
//  PhotoLibraryPermissionManagerService.swift
//  Platform
//
//  Created by wonsik on 4/11/26.
//

import Domain
import Photos

extension PhotoLibraryAuthStatus {
  static func from(_ status: PHAuthorizationStatus) -> PhotoLibraryAuthStatus {
    switch status {
    case .notDetermined:
      return .notDetermined
    case .authorized:
      return .authorized
    case .limited:
      return .limited
    case .denied:
      return .denied
    case .restricted:
      return .restricted
    @unknown default:
      return .denied
    }
  }
}

public final class PhotoLibraryPermissionManagerService: PhotoLibraryPermissionManagerProtocol {
  public init() {}

  public func currentStatus() -> PhotoLibraryAuthStatus {
    let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    return .from(status)
  }

  public func requestAuthorization() async -> PhotoLibraryAuthStatus {
    let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
    return .from(status)
  }
}
