//
//  SignInResponse.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

struct SignInResponseDTO: Decodable {
    let id: Int
    let loginId: String?
    let name: String?
    let phone: String?
    let status: MemberStatus?
    let role: MemberRole?
    let createdAt: String?
    let updatedAt: String?
}

extension SignInResponseDTO {
    func toDomain() -> User {
        User(
            id: id,
            name: name ?? "",
            phoneNumber: phone ?? "",
            status: status ?? .undefined,
            role: role ?? .undefined
        )
    }
}
