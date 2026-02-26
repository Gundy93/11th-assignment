//
//  AttendancesService.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

import Dependencies

protocol AttendancesService {
    func attend(
        hashValue: String,
        memberId: Int
    ) async throws -> ResponseError?
}

private enum AttendancesServiceKey: DependencyKey {
    static let liveValue: any AttendancesService = DefaultAttendancesService(session: AlamofireSession(eventMonitor: NetworkLogger(apiName: "Auth")))
}

extension DependencyValues {
    var attendancesService: any AttendancesService {
        get { self[AttendancesServiceKey.self] }
        set { self[AttendancesServiceKey.self] = newValue }
    }
}

struct DefaultAttendancesService: AttendancesService {
    private let session: NetworkSession

    init(session: NetworkSession) {
        self.session = session
    }

    func attend(
        hashValue: String,
        memberId: Int
    ) async throws -> ResponseError? {
        let requestBody = AttendRequest(
            hashValue: hashValue,
            memberId: memberId
        )
        let api = AttendancesAPI.attend(requestBody)
        let response = try await session.request(
            api.asURLRequest(),
            as: ResponseDTO<AttendanceResponseDTO>.self
        )
        
        if let error = response.error {
            throw error
        }
        
        if let responseError = response.data?.error {
            return responseError.code
        }
        
        return nil
    }
}
