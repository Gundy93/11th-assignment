//
//  NetworkLogger.swift
//  Prography
//
//  Created by Jun Young Lee on 2/24/26.
//

import Foundation
import Alamofire

final class NetworkLogger: EventMonitor {
    private let apiName: String
    let queue: DispatchQueue
    
    init(apiName: String = "") {
        self.apiName = apiName
        self.queue = DispatchQueue(label: "💜 APIEventLogger-\(apiName)")
    }
    
    func requestDidFinish(_ request: Request) {
        #if DEBUG
        print("🛰 \(apiName) NETWORK Event LOG\n"
              + "✅ Request successfully\n"
              + "-------------------------------\n"
              + "URL: \(request.request?.url?.absoluteString ?? "")\n"
              + "Method: \(request.request?.httpMethod ?? "")\n"
              + "Headers: \(request.request?.allHTTPHeaderFields ?? [:])\n"
              + "Body: \(request.request?.httpBody?.toPrettyPrintedString ?? "")\n"
        )
        #endif
    }
    
    func request<Value>(
        _ request: DataRequest,
        didParseResponse response: DataResponse<Value, AFError>
    ) {
        #if DEBUG
        switch response.result {
        case .success:
            let url = request.request?.url?.absoluteString ?? ""
            let statusCode = response.response?.statusCode ?? 0
            let dataString = response.data?.toPrettyPrintedString ?? ""
            let headers = response.response?.allHeaderFields
                .map { "\($0.key): \($0.value)" }
                .joined(separator: "\n") ?? "None"

            print("""
            🛰 \(apiName) NETWORK Event LOG
            ✅ Response parsed successfully
            -------------------------------
            URL: \(url)
            StatusCode: \(statusCode)
            Result: \(response.result)\n
            Headers:
            \(headers)
            Data:
            \(dataString)
            """)

        case let .failure(error):
            guard let statusCode = response.response?.statusCode else { return }
                
            switch statusCode {
            case 400...499:
                logError(
                    label: "Client Error: Bad Request",
                    request: request,
                    response: response,
                    error: error
                )
            case 500...599:
                logError(
                    label: "Server Error: Problem with the server",
                    request: request,
                    response: response,
                    error: error
                )
            default:
                logError(
                    label: "Unexpected Error: \(error.errorDescription ?? "")",
                    request: request,
                    response: response,
                    error: error
                )
            }
        }
        #endif
    }
    
    private func logError(
        label: String,
        request: DataRequest,
        response: DataResponse<some Any, AFError>,
        error: AFError
    ) {
        print("🛰 \(apiName) NETWORK Event LOG\n"
              + "❌ \(label)\n"
              + "-------------------------------\n"
              + "URL: \(request.request?.url?.absoluteString ?? "")\n"
              + "Result: \(response.result)\n"
              + "StatusCode: \(response.response?.statusCode ?? 0)\n"
              + "Data: \(response.data?.toPrettyPrintedString ?? "")\n"
              + "Error: \(error.errorDescription ?? "")\n"
        )
    }
}

fileprivate extension Data {
    var toPrettyPrintedString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString as String
    }
}
