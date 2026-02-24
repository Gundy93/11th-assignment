//
//  NetworkCoder.swift
//  Prography
//
//  Created by Jun Young Lee on 2/24/26.
//

import Foundation

enum NetworkCoder {
    private static let decoder = JSONDecoder()
    
    static func decode<T>(
        _ type: T.Type,
        from data: Data
    ) throws -> T where T : Decodable {
        try decoder.decode(
            type,
            from: data
        )
    }
}
