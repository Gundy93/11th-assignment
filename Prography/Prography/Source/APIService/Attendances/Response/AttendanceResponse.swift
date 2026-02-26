//
//  AttendanceResponse.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

struct AttendanceResponseDTO: Decodable {
    let id: Int
    let sessionId: Int?
    let memberId: Int?
    let status: AttendanceStatus?
    let lateMinutes: Int?
    let penaltyAmount: Int?
    let reason: String?
    let checkedInAt: String?
    let createdAt: String?
    let updatedAt: String?
}
