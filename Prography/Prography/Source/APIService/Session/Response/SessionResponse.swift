//
//  SessionResponse.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

import Foundation

typealias SessionResponseDTO = [SessionDTO]

struct SessionDTO: Decodable {
    let id: Int
    let title: String?
    let date: String?
    let time: String?
    let location: String?
    let status: SessionStatus?
    let createdAt: String?
    let updatedAt: String?
}

extension SessionResponseDTO {
    func toDomain() -> [Session] {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return compactMap { dto in
            guard let date = dto.date,
                  let time = dto.time,
                  let sessionDate = formatter.date(from: "\(date) \(time)") else {
                return nil
            }
            
            return Session(
                id: dto.id,
                title: dto.title ?? "",
                date: sessionDate,
                location: dto.location ?? "",
                status: dto.status ?? .undefined
            )
        }
    }
}
