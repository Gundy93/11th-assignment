//
//  MemberStatus.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

enum MemberStatus: String, Decodable {
    case active = "ACTIVE"
    case inactive = "INACTIVE"
    case withdrawn = "WITHDRAWN"
    case undefined = "UNDEFINED"
    
    init(from decoder: any Decoder) throws {
        let rawValue = try decoder.singleValueContainer().decode(String.self)
        
        self = MemberStatus(rawValue: rawValue) ?? .undefined
    }
}
