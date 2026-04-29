//
//  PhotoLibraryPermissionManagerKey+Live.swift
//  DependencyInjection
//
//  Created by wonsik on 4/11/26.
//

import Dependencies
import Domain
import Platform

extension PhotoLibraryPermissionManagerKey: @retroactive DependencyKey {
  public static var liveValue: any PhotoLibraryPermissionManagerProtocol {
    PhotoLibraryPermissionManagerService()
  }
}
