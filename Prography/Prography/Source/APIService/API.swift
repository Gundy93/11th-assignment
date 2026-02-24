//
//  API.swift
//  Prography
//
//  Created by Jun Young Lee on 2/25/26.
//

import Alamofire

protocol API: URLRequestConvertible {
    var baseURLString: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
}
