//
//  PrographySession.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

import Foundation

struct PrographySession: Equatable {
    let id: Int
    let title: String
    let date: Date
    let location: String
    let status: SessionStatus
}
