//
//  AuthAPI.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

import Foundation
import Alamofire

enum AuthAPI: API {
    case signIn(SignInRequest)

    var baseURLString: String {
        AppURL.host.string
    }

    var method: HTTPMethod {
        switch self {
        case .signIn:
                .post
        }
    }

    var path: String {
        switch self {
        case .signIn:
            "/api/v1/auth/login"
        }
    }

    func asURLRequest() throws -> URLRequest {
        switch self {
        case .signIn(let requestBody):
            try request(requestBody: requestBody)
        }
    }
}
