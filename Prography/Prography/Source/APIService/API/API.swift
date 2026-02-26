//
//  API.swift
//  Prography
//
//  Created by Jun Young Lee on 2/25/26.
//

import Foundation
import Alamofire

protocol API: URLRequestConvertible {
    var baseURLString: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
}

extension API {
    private var urlString: String {
        let normalizedPath = path.hasPrefix("/") ? path : "/\(path)"
        
        return baseURLString + normalizedPath
    }
    
    private func makeURL() throws -> URL {
        guard let components = URLComponents(string: urlString),
              let url = components.url else {
            throw APIError.invalidURL
        }
        
        return url
    }
}

extension API {
    func request() throws -> URLRequest {
        return try URLRequest(
            url: makeURL(),
            method: method
        )
    }

    func request(requestBody: Encodable) throws -> URLRequest {
        var request = try request()
        
        request.httpBody = try JSONEncoder().encode(requestBody)
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        return request
    }

    func request(queryItems: [URLQueryItem]) throws -> URLRequest {
        var components = URLComponents(string: urlString)
        
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        
        return try URLRequest(
            url: url,
            method: method
        )
    }
}
