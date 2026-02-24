//
//  NetworkSession.swift
//  Prography
//
//  Created by Jun Young Lee on 2/24/26.
//

import Alamofire

protocol NetworkSession {
    func request<T: Decodable & Sendable>(
        _ convertible: URLRequestConvertible,
        as type: T.Type
    ) async throws -> NetworkResponse<T>
}
