//
//  ImageService.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/25/25.
//

import Foundation
import Moya
import UIKit

final class ImageService {
    
    static let shared = ImageService()
    private let provider = MoyaProvider<ImageAPI>()
    
    private init() {}
    
    // MARK: - 이미지 업로드 (POST /image/upload)
    func uploadImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        provider.request(.upload(image: image)) { result in
            switch result {
            case .success(let response):
                do {
                    // 1. 공통 래퍼(APIResponse)로 디코딩
                    // T 타입은 ImageUploadResult (내부에 url이 있음)
                    let decoded = try JSONDecoder().decode(APIResponse<ImageUploadResult>.self, from: response.data)
                    
                    // 2. 성공 시 URL 문자열만 추출해서 전달
                    completion(.success(decoded.result.url))
                    
                } catch {
                    print("❌ 이미지 업로드 디코딩 실패:", error)
                    
                    // 디버깅용: 데이터가 어떻게 왔는지 확인
                    if let str = String(data: response.data, encoding: .utf8) {
                        print("📄 원본 데이터: \(str)")
                    }
                    
                    completion(.failure(error))
                }
            case .failure(let error):
                print("❌ 이미지 업로드 요청 실패:", error)
                completion(.failure(error))
            }
        }
    }
}
