//
//  AuthManager.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/3/25.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    private init() {}

    // 개발용 하드코딩 토큰
    private let devToken = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzdHJpbmciLCJpYXQiOjE3NjMzNzczMzMsImV4cCI6MTc2MzQ2MzczM30.QQIeJMZLQeoy20aVLra1rTXWk1X32UdibofgNQAeByY"

    // 현재 토큰 (실제 로그인 시에는 여기 업데이트)
    var accessToken: String {
        // 로그인 기능 연결 후에는 UserDefaults 등에서 불러오게 변경 가능
        return UserDefaults.standard.string(forKey: "accessToken") ?? devToken
    }
}
