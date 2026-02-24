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
    func request() throws -> URLRequest {
        guard let components = URLComponents(string: baseURLString + path),
              let url = components.url else {
            throw NSError(
                domain: "Invalid URL",
                code: -1
            )
        }

        return try URLRequest(
            url: url,
            method: method
        )
    }

    func request(requestBody: Encodable) throws -> URLRequest {
        guard let components = URLComponents(string: baseURLString + path),
              let url = components.url else {
            throw NSError(
                domain: "Invalid URL",
                code: -1
            )
        }
        var request = try URLRequest(
            url: url,
            method: method
        )
        let parameters = requestBody.toDictionary()

        request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        return request
    }

    func request(queryItems: [URLQueryItem]) throws -> URLRequest {
        var components = URLComponents(string: baseURLString + path)

        components?.queryItems = queryItems

        guard let url = components?.url else {
            throw NSError(
                domain: "Invalid URL",
                code: -1
            )
        }

        return try URLRequest(
            url: url,
            method: method
        )
    }
}

fileprivate extension Encodable {
    func toDictionary() -> [String: Any] {
        do {
            let data = try JSONEncoder().encode(self)
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            guard let dictionaryData = jsonObject as? [String: Any] else {
                #if DEBUG
                print("Encodable.toDictionary: Failed to cast JSON object to [String: Any] for type \(type(of: self))")
                #endif
                return [:]
            }
            return dictionaryData
        } catch {
            #if DEBUG
            print("Encodable.toDictionary: Failed to encode type \(type(of: self)) to JSON: \(error)")
            #endif
            return [:]
        }
    }
}
