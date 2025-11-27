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
    private let tokenKey = "accessToken"
    private let memberIdKey = "currentMemberId"
    // 개발용 하드코딩 토큰
    private let devToken = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzdHJpbmciLCJpYXQiOjE3NjQyMTIyOTIsImV4cCI6MTc2NDI5ODY5Mn0.QUl3TfGODeAn4Ha4F7Hm4_LJsorsvO_9nFcrDnDcucs"

    // 현재 토큰 (실제 로그인 시에는 여기 업데이트)
    var accessToken: String {
        // 로그인 기능 연결 후에는 UserDefaults 등에서 불러오게 변경 가능
        get {
            return UserDefaults.standard.string(forKey: "accessToken") ?? devToken
        }
        
        set {
            // ‼️ [핵심 수정] 값을 대입(=)하면 저장되도록 set 블록 추가
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
    
    var currentMemberId: Int {
        get {
            // 저장된 ID가 없으면 0 반환 (로그인 전)
            return UserDefaults.standard.integer(forKey: memberIdKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: memberIdKey)
        }
    }
}
