//
//  DiagnosisDocumentView.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/30/25.
//

import SwiftUI

struct DiagnosisDocumentView: View {
    let records: [MedicalRecord]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // MARK: - 반복되는 구름 배경
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    ForEach(0..<2) { _ in
                        Image(.cloudBG)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width)
                    }
                }
            }
            .ignoresSafeArea()
            
            // MARK: - ScrollView 콘텐츠
            ScrollView {
                VStack {
                    Spacer().padding(.top, 80)
                    ForEach(records) { record in
                        DocumentComponent(record: record)
                            .padding(.bottom, 8)
                    }
                    Spacer()
                    
                    // 맨 밑 잔디 배경
                    ZStack {
                        Image(.grassBG)
                            .resizable()
                            .scaledToFit()
                            .padding(.top, 40)
                        CharacterSpeechComponent(characterImage: .doctor1, textString: "지금까지의\n진료기록이란다.")
                    }
                }
//                .padding(.vertical, 20)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    let sampleRecords = [
        MedicalRecord(plantName: "똥맛토", date: "2025.09.03", diagnosis: .normal, icon: Image(.tomato)),
        MedicalRecord(plantName: "토맛똥", date: "2025.09.07", diagnosis: .disease("점무늬병"), icon: Image(.tomato)),
        MedicalRecord(plantName: "고추", date: "2025.09.10", diagnosis: .normal, icon: Image(.basil))
    ]
    DiagnosisDocumentView(records: sampleRecords)
}
