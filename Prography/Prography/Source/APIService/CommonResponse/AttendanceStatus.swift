//
//  AttendanceStatus.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

enum AttendanceStatus: String, Decodable {
    case present = "PRESENT"
    case late = "LATE"
    case undefined = "UNDEFINED"
    
    init(from decoder: any Decoder) throws {
        let rawValue = try decoder.singleValueContainer().decode(String.self)
        
        self = AttendanceStatus(rawValue: rawValue) ?? .undefined
    }
}
