//
//  AlamofireSession.swift
//  Prography
//
//  Created by Jun Young Lee on 2/24/26.
//

import Foundation
import Alamofire

final class AlamofireSession: NetworkSession {
    private let session: Session
    
    init(
        interceptor: RequestInterceptor? = nil,
        eventMonitor: EventMonitor = NetworkLogger(apiName: "Prography Default")
    ) {
        let configuration = URLSessionConfiguration.default
        
        configuration.timeoutIntervalForRequest = 30
        session = Session(
            configuration: configuration,
            interceptor: interceptor,
            eventMonitors: [eventMonitor]
        )
    }
    
    func request<T: Decodable & Sendable>(
        _ convertible: URLRequestConvertible,
        as type: T.Type
    ) async throws -> NetworkResponse<T> {
        let response = await session.request(convertible)
            .validate()
            .serializingData()
            .response
        let statusCode = response.response?.statusCode
        let rawData = response.data
        var decodedData: T? = nil
        
        if let rawData {
            decodedData = try NetworkCoder.decode(
                T.self,
                from: rawData
            )
        }
        
        return NetworkResponse(
            statusCode: statusCode,
            data: decodedData,
            rawData: rawData,
            error: response.error
        )
    }
}
