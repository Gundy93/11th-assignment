//
//  SessionStatus.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

enum SessionStatus: String, Decodable {
    case scheduled = "SCHEDULED"
    case inProgress = "IN_PROGRESS"
    case completed = "COMPLETED"
    case undefined = "UNDEFINED"
    
    init(from decoder: any Decoder) throws {
        let rawValue = try decoder.singleValueContainer().decode(String.self)
        
        self = SessionStatus(rawValue: rawValue) ?? .undefined
    }
}
