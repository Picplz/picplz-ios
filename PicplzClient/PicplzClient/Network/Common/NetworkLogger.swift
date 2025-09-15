//
//  NetworkLogger.swift
//  PicplzClient
//
//  Created by 임영택 on 8/5/25.
//

import Foundation
import Alamofire
import os.log

final class NetworkLogger: EventMonitor {
    let queue = DispatchQueue(label: "NetworkLogger")
    private let logger = Logger.of("NetworkLogger")

    func requestDidResume(_ request: Request) {
        guard let httpRequest = request.request else {
            logger.info("🚀 RequestStarted {\"error\":\"URLRequest is nil\"}")
            return
        }

        let method = httpRequest.httpMethod ?? "UNKNOWN"
        let url = httpRequest.url?.absoluteString ?? "No URL"
        let headers = httpRequest.allHTTPHeaderFields ?? [:]
        let body = httpRequest.httpBody.flatMap { String(data: $0, encoding: .utf8) } ?? ""

        // swiftlint:disable:next line_length
        logger.info("🚀 RequestStarted {\"method\":\"\(method)\",\"url\":\"\(url)\",\"headers\":\(headers),\"body\":\"\(body.replacingOccurrences(of: "\"", with: "\\\""))\"}")
    }

    func requestDidFinish(_ request: Request) {
        let statusCode = request.response?.statusCode ?? -1
        let url = request.request?.url?.absoluteString ?? "Unknown URL"

        logger.info("✅ RequestFinished {\"status\":\(statusCode),\"url\":\"\(url)\"}")
    }

    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        let url = request.request?.url?.absoluteString ?? "Unknown URL"

        switch response.result {
        case .success:
            if let data = response.data,
               let body = String(data: data, encoding: .utf8) {
                logger.info("📥 ResponseSuccess {\"url\":\"\(url)\",\"body\":\"\(body.replacingOccurrences(of: "\"", with: "\\\""))\"}")
            } else {
                logger.info("📥 ResponseSuccess {\"url\":\"\(url)\",\"body\":\"\"}")
            }

        case .failure(let error):
            let errorMessage = error.localizedDescription.replacingOccurrences(of: "\"", with: "\\\"")
            if let data = response.data,
               let body = String(data: data, encoding: .utf8) {
                // swiftlint:disable:next line_length
                logger.error("❌ ResponseError {\"url\":\"\(url)\",\"error\":\"\(errorMessage)\",\"body\":\"\(body.replacingOccurrences(of: "\"", with: "\\\""))\"}")
            } else {
                logger.error("❌ ResponseError {\"url\":\"\(url)\",\"error\":\"\(errorMessage)\",\"body\":\"\"}")
            }
        }
    }
}
