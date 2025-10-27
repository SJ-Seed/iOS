//
//  DocumentComponent.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/30/25.
//

import SwiftUI

struct DocumentComponent: View {
    let record: MedicalRecord
    
    var body: some View {
        HStack {
//            Spacer()
            CloudPlantComponent(icon: record.icon)
                .padding()
                .padding(.trailing, 30)
//            Spacer()
            VStack(alignment: .leading) {
                HStack {
                    Text(record.plantName)
                        .font(Font.OwnglyphMeetme.regular.font(size: 30))
                        .foregroundStyle(Color.green1)
                    Button {
                        print("info")
                    } label: {
                        Image("info")
                            .foregroundStyle(Color(.green1))
                            .offset(y: -1)
                    }
                }
                Group {
                    Text(record.date)
                    Text(record.diagnosis.displayText)
                }
                .font(Font.OwnglyphMeetme.regular.font(size: 20))
            }
            .padding(.trailing, 30)
//            Spacer()
        }
        .frame(width: 350, height: 180)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(record.diagnosis.backgroundColor)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        )
    }
}

#Preview {
    let record = MedicalRecord(plantName: "또마똥", date: "2025.09.03", diagnosis: .disease("점무늬병"), icon: Image(.sprout))
    DocumentComponent(record: record)
}
