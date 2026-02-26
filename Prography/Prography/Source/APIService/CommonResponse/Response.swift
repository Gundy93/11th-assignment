//
//  Response.swift
//  Prography
//
//  Created by Jun Young Lee on 2/25/26.
//

struct ResponseDTO<T: Decodable>: Decodable {
    let success: Bool
    let data: T?
    let error: ResponseErrorDTO?
}
