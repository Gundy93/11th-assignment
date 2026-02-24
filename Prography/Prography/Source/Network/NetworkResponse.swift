//
//  NetworkResponse.swift
//  Prography
//
//  Created by Jun Young Lee on 2/24/26.
//

import Foundation

struct NetworkResponse<T> {
    let statusCode: Int?
    let data: T?
    let rawData: Data?
    let error: Error?
}
