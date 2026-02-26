//
//  MemberRole.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

enum MemberRole: String, Decodable {
    case member = "MEMBER"
    case admin = "ADMIN"
    case undefined = "UNDEFINED"
    
    init(from decoder: any Decoder) throws {
        let rawValue = try decoder.singleValueContainer().decode(String.self)
        
        self = MemberRole(rawValue: rawValue) ?? .undefined
    }
}
