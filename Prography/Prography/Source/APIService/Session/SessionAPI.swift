//
//  SessionAPI.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

import Foundation
import Alamofire

enum SessionAPI: API {
    case sessions

    var baseURLString: String {
        AppURL.host.string
    }

    var method: HTTPMethod {
        switch self {
        case .sessions:
                .get
        }
    }

    var path: String {
        switch self {
        case .sessions:
            "/api/v1/sessions"
        }
    }

    func asURLRequest() throws -> URLRequest {
        switch self {
        case .sessions:
            try request()
        }
    }
}
