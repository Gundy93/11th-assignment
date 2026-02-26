//
//  AppURL.swift
//  Prography
//
//  Created by Jun Young Lee on 2/25/26.
//

import Foundation

enum AppURL {
    case host

    var string: String {
        switch self {
        case .host:
            "http://localhost:8080"
        }
    }

    var url: URL? {
        URL(string: string)
    }
}
