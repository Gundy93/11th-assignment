//
//  ResponseError.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

struct ResponseErrorDTO: Decodable {
    let code: ResponseError
    let message: String?
}

enum ResponseError: String, Decodable, Error {
    case invalidInput = "INVALID_INPUT"
    case internalError = "INTERNAL_ERROR"
    case loginFailed = "LOGIN_FAILED"
    case memberWithdrawn = "MEMBER_WITHDRAWN"
    case memberNotFound = "MEMBER_NOT_FOUND"
    case duplicateLoginId = "DUPLICATE_LOGIN_ID"
    case memberAlreadyWithdrawn = "MEMBER_ALREADY_WITHDRAWN"
    case cohortNotFound = "COHORT_NOT_FOUND"
    case partNotFound = "PART_NOT_FOUND"
    case teamNotFound = "TEAM_NOT_FOUND"
    case cohortMemberNotFound = "COHORT_MEMBER_NOT_FOUND"
    case sessionNotFound = "SESSION_NOT_FOUND"
    case sessionAlreadyCancelled = "SESSION_ALREADY_CANCELLED"
    case sessionNotInProgress = "SESSION_NOT_IN_PROGRESS"
    case qrNotFound = "QR_NOT_FOUND"
    case qrInvalid = "QR_INVALID"
    case qrExpired = "QR_EXPIRED"
    case qrAlreadyActive = "QR_ALREADY_ACTIVE"
    case attendanceNotFound = "ATTENDANCE_NOT_FOUND"
    case attendanceAlreadyChecked = "ATTENDANCE_ALREADY_CHECKED"
    case excuseLimitExceeded = "EXCUSE_LIMIT_EXCEEDED"
    case depositInsufficient = "DEPOSIT_INSUFFICIENT"
    case undefined = "UNDEFINED"
    
    init(from decoder: any Decoder) throws {
        let rawValue = try decoder.singleValueContainer().decode(String.self)
        
        self = ResponseError(rawValue: rawValue) ?? .undefined
    }
}
