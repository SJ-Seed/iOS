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
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                return .requestPlain
            }
            
            // 2. MultipartFormData 생성
            // name: 서버가 요구하는 필드명 ("file")
            // fileName: 서버에 저장될 파일명 (임의 지정 가능)
            // mimeType: 파일 타입 ("image/jpeg" 또는 "image/png")
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
