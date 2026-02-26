//
//  NetworkSession.swift
//  Prography
//
//  Created by Jun Young Lee on 2/24/26.
//

import Foundation

protocol NetworkSession {
    func request<T: Decodable>(
        _ request: URLRequest,
        as type: T.Type
    ) async throws -> NetworkResponse<T>
}
