//
//  HospitalModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/7/25.
//

import Foundation
import SwiftUI

struct MedicalRecord: Identifiable {
    let id = UUID()
    let plantName: String
    let date: String
    let diagnosis: DiagnosisType
    let icon: Image
}

enum DiagnosisType {
    case normal
    case disease(String)
    
    var backgroundColor: Color {
        switch self {
        case .normal:
            return .ivory1
        case .disease:
            return .red1
        }
    }
    
    var displayText: String {
        switch self {
        case .normal:
            return "정상"
        case .disease(let name):
            return name
        }
    }
}
