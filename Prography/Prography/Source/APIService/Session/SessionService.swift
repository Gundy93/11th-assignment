//
//  SessionService.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

import Dependencies

protocol SessionService {
    func fetchSessions() async throws -> Result<[Session], ResponseError>
}

private enum SessionServiceKey: DependencyKey {
    static let liveValue: any SessionService = DefaultSessionService(session: AlamofireSession(eventMonitor: NetworkLogger(apiName: "Session")))
}

extension DependencyValues {
    var sessionService: any SessionService {
        get { self[SessionServiceKey.self] }
        set { self[SessionServiceKey.self] = newValue }
    }
}

struct DefaultSessionService: SessionService {
    private let session: NetworkSession

    init(session: NetworkSession) {
        self.session = session
    }

    func fetchSessions() async throws -> Result<[Session], ResponseError> {
        let api = SessionAPI.sessions
        let response = try await session.request(
            api.asURLRequest(),
            as: ResponseDTO<SessionResponseDTO>.self
        )
        
        if let error = response.error {
            throw error
        }
        
        if let responseError = response.data?.error {
            return .failure(responseError.code)
        }
        
        guard let dto = response.data?.data else {
            throw APIError.invalidData
        }
        
        return .success(dto.toDomain())
    }
}
