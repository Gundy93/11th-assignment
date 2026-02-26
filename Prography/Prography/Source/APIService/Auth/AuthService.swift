//
//  AuthService.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

import Dependencies

protocol AuthService {
    func signIn(
        id: String,
        password: String
    ) async throws -> User
}

private enum AuthServiceKey: DependencyKey {
    static let liveValue: any AuthService = DefaultAuthService(session: AlamofireSession(eventMonitor: NetworkLogger(apiName: "Auth")))
}

extension DependencyValues {
    var authService: any AuthService {
        get { self[AuthServiceKey.self] }
        set { self[AuthServiceKey.self] = newValue }
    }
}

struct DefaultAuthService: AuthService {
    private let session: NetworkSession

    init(session: NetworkSession) {
        self.session = session
    }

    func signIn(
        id: String,
        password: String
    ) async throws -> User {
        let requestBody = SignInRequest(
            loginId: id,
            password: password
        )
        let api = AuthAPI.signIn(requestBody)
        let response = try await session.request(
            api.asURLRequest(),
            as: SignInResponseDTO.self
        )
        
        if let error = response.error {
            throw error
        }
        
        guard let data = response.data else {
            throw APIError.invalidData
        }
        
        return data.toDomain()
    }
}
