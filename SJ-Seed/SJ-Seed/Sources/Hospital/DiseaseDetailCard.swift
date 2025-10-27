//
//  DiseaseDetailCard.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/28/25.
//

import SwiftUI

struct DiseaseDetailCard: View {
    let diseaseName: String
    let symptom: String
    let cause: String
    let treatment: String

    var body: some View {
        // 병 이름
        Text(diseaseName)
            .font(Font.OwnglyphMeetme.regular.font(size: 28))
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity)
            .background(.red1)
            .cornerRadius(20)
            .foregroundStyle(.brown1)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)
            .padding(.bottom, 10)
        
        VStack(alignment: .center, spacing: 16) {
            // 증상
            VStack(alignment: .center, spacing: 12) {
                Text("증상")
                    .font(Font.OwnglyphMeetme.regular.font(size: 28))
                    .foregroundStyle(.green1)
                Text(symptom)
                    .font(Font.OwnglyphMeetme.regular.font(size: 22))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.bottom, 20)
            
            // 발생 원인
            VStack(alignment: .center, spacing: 12) {
                Text("발생 원인")
                    .font(Font.OwnglyphMeetme.regular.font(size: 28))
                    .foregroundStyle(.green1)
                Text(cause)
                    .font(Font.OwnglyphMeetme.regular.font(size: 22))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.bottom, 20)
            
            // 치료 방법
            VStack(alignment: .center, spacing: 12) {
                Text("치료 방법")
                    .font(Font.OwnglyphMeetme.regular.font(size: 28))
                    .foregroundStyle(.green1)
                Text(treatment)
                    .font(Font.OwnglyphMeetme.regular.font(size: 22))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 40)
        .background(Color.red1)
        .cornerRadius(20)
        .padding(.horizontal, 40)
        .shadow(color: .brown.opacity(0.2), radius: 3, x: 0, y: 2)
    }
}

#Preview {
    DiseaseDetailCard(
        diseaseName: "점무늬병",
        symptom: "잎에 회갈색, 암갈색의 작은 반점이 생겨요. 심하게 감염되면 잎은 황색으로 변하면서 마르고 금방 시들어요.",
        cause: "병원균은 씨앗이나 병든 부위에서 곰팡이 형태로 겨울을 보낸 후, 포자를 만들어서 공기로 전염돼요. 따뜻하고 습한 환경에서 많이 발생하고, 감염된 후 5일 이내에 증상이 나타나요.",
        treatment: "씨앗을 선별하고, 소독한 후 심어야 해요. 병든 잎은 빨리 제거해야 하고, 온실에서는 내부가 너무 습하지 않도록 환기를 자주 시켜야 해요."
    )
}
