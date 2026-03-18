//
//  LocationManagerKey+Live.swift
//  DependencyInjection
//
//  Created by 임영택 on 3/18/26.
//

import Domain
import Platform
import Dependencies

extension LocationManagerKey: @retroactive DependencyKey {
  public static var liveValue: any LocationManagerProtocol {
    LocationManagerService()
  }
}
