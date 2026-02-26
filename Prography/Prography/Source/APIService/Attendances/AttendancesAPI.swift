//
//  AttendancesAPI.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

import Foundation
import Alamofire

enum AttendancesAPI: API {
    case attend(AttendRequest)

    var baseURLString: String {
        AppURL.host.string
    }

    var method: HTTPMethod {
        switch self {
        case .attend:
                .post
        }
    }

    var path: String {
        switch self {
        case .attend:
            "/api/v1/attendances"
        }
    }

    func asURLRequest() throws -> URLRequest {
        switch self {
        case .attend(let requestBody):
            try request(requestBody: requestBody)
        }
    }
}
