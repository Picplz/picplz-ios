//
//  AreasRepositoryProtocol.swift
//  Domain
//
//  Created by 임영택 on 3/15/26.
//

import Dependencies
import Foundation

public protocol AreasRepositoryProtocol {
  func searchAreas(keyword: String) async throws -> [Area]
  func getNearbyAreas(radius: Int, latitude: Double, longitude: Double) async throws -> [Area]
}

struct UnimplementedAreasRepository: AreasRepositoryProtocol {
  func searchAreas(keyword: String) async throws -> [Area] {
    fatalError("구현되지 않은 메서드를 호출했습니다")
  }
  
  func getNearbyAreas(radius: Int, latitude: Double, longitude: Double) async throws -> [Area] {
    fatalError("구현되지 않은 메서드를 호출했습니다")
  }
}

public enum AreasRepositoryKey: TestDependencyKey {
  public static var testValue: AreasRepositoryProtocol = UnimplementedAreasRepository()
}

public extension DependencyValues {
  var areasRepository: AreasRepositoryProtocol {
    get { self[AreasRepositoryKey.self] }
    set { self[AreasRepositoryKey.self] = newValue }
  }
}
