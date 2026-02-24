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

struct ResponseErrorDTO: Decodable {
    let code: String
    let message: String?
}

enum ResponseError: String, Error {
    case INVALID_INPUT
    case INTERNAL_ERROR
    case LOGIN_FAILED
    case MEMBER_WITHDRAWN
    case MEMBER_NOT_FOUND
    case DUPLICATE_LOGIN_ID
    case MEMBER_ALREADY_WITHDRAWN
    case COHORT_NOT_FOUND
    case PART_NOT_FOUND
    case TEAM_NOT_FOUND
    case COHORT_MEMBER_NOT_FOUND
    case SESSION_NOT_FOUND
    case SESSION_ALREADY_CANCELLED
    case SESSION_NOT_IN_PROGRESS
    case QR_NOT_FOUND
    case QR_INVALID
    case QR_EXPIRED
    case QR_ALREADY_ACTIVE
    case ATTENDANCE_NOT_FOUND
    case ATTENDANCE_ALREADY_CHECKED
    case EXCUSE_LIMIT_EXCEEDED
    case DEPOSIT_INSUFFICIENT
}
