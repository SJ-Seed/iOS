//
//  LoginResponse.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/3/25.
//

import Foundation

struct LoginResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: LoginResult
}

struct LoginResult: Codable {
    let memberId: String
    let name: String
    let loginId: String
    let token: String
}
