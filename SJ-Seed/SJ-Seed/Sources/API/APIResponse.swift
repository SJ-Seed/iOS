//
//  APIResponse.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/3/25.
//

import Foundation

struct APIResponse<T: Codable>: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: T
}
