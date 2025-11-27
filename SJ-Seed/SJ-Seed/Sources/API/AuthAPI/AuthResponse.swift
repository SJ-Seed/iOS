//
//  AuthResponse.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/3/25.
//

import Foundation

// MARK: - 회원가입 요청 Body
struct SignUpRequest: Encodable {
    let name: String
    let year: Int
    let loginId: String
    let password: String
    let phoneNumber: String
}

// MARK: - 로그인 요청 Body
struct SignInRequest: Encodable {
    let loginId: String
    let password: String
}
// MARK: - 1. 회원가입 결과 (POST /member/signup)
struct SignUpResult: Codable {
    let name: String
    let year: Int
    let loginId: String
    let encodedPassword: String
    let phoneNumber: String
}

// MARK: - 2. 로그인 결과 (POST /member/signin)
struct SignInResult: Codable {
    let memberId: String
    let name: String
    let loginId: String
    let token: String
}
