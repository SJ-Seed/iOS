//
//  MemberResponse.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/27/25.
//


import Foundation

// MARK: - 회원 상세 정보 조회 (GET /member/detail/{memberId})
struct MemberDetailResult: Codable {
    let name: String
    let plantNum: Int  // 식물 친구 수
    let pieceNum: Int  // 도감 조각 수
}
