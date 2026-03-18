import Foundation
import Moya

extension MoyaProvider {
  /// Moya 요청을 async-await으로 처리하고 HTTP 에러를 확인합니다.
  public func requestAsync(_ target: Target) async throws -> Response {
    try await withCheckedThrowingContinuation { continuation in
      self.request(target) { result in
        switch result {
        case .success(let response):
          do {
            try HTTPError.checkError(response: response)
            continuation.resume(returning: response)
          } catch {
            continuation.resume(throwing: error)
          }
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }

  /// Moya 요청을 async-await으로 처리하고, HTTP 에러 확인 후 BaseResponseDTO로 매핑하여 data를 반환합니다.
  public func requestWithDTO<T: Decodable>(_ target: Target) async throws -> T {
    let response = try await self.requestAsync(target)
    let dto = try response.map(BaseResponseDTO<T>.self, using: .customDateDecoder)
    return dto.data
  }
}
