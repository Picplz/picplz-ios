//
//  BundleInfoValue.swift
//  Common
//
//  Created by 임영택 on 2/26/26.
//

import Foundation

public struct BundleInfoValue<T> {
  let key: String
  
  public init(key: String) {
    self.key = key
  }
  
  public var value: T? {
    Bundle.main.infoDictionary?[key] as? T
  }
}
