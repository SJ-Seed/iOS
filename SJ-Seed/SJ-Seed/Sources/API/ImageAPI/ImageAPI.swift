//
//  ImageAPI.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/25/25.
//

import Foundation
import Moya
import UIKit

enum ImageAPI {
    case upload(image: UIImage)
}

extension ImageAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://sj-seed.com/api")!
    }
    
    var path: String {
        switch self {
        case .upload:
            return "/image/upload"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .upload:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .upload(let image):
            // 1. 이미지 리사이징 (너비를 800px로 줄임 -> 용량 대폭 감소)
            // (원본이 800보다 작으면 그대로 둠)
            let resizedImage = image.size.width > 800 ? image.resized(toWidth: 800) : image
            
            // 2. JPEG 압축 (0.8 -> 0.5로 낮춤)
            // 리사이징된 이미지를 사용해야 함
            guard let finalImage = resizedImage,
                  let imageData = finalImage.jpegData(compressionQuality: 0.5) else {
                return .requestPlain
            }
            
            // (디버깅용) 줄어든 용량 확인
            print("📦 업로드 이미지 크기: \(Double(imageData.count) / 1024.0 / 1024.0) MB")
            let formData = MultipartFormData(
                provider: .data(imageData),
                name: "file",
                fileName: "upload_image.jpg",
                mimeType: "image/jpeg"
            )
            
            return .uploadMultipart([formData])
        }
    }
    
    var headers: [String : String]? {
        return [
            "accept": "application/json",
            "Authorization": "Bearer \(AuthManager.shared.accessToken)"
        ]
    }
}
