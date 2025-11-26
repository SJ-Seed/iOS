//
//  ListComponent.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/30/25.
//

import SwiftUI

struct ListComponent<T: PlantDisplayable>: View {
    let item: T
    var onInfoTap: () -> Void
    
    var body: some View {
        HStack {
//            Spacer()
            CloudPlantComponent(icon: item.plantProfile.icon)
                .padding()
                .padding(.trailing, 30)
//            Spacer()
            VStack(alignment: .leading) {
                HStack {
                    Text(item.plantProfile.name)
                        .font(Font.OwnglyphMeetme.regular.font(size: 30))
                        .foregroundStyle(Color.green1)
                    Button {
                        onInfoTap()
                    } label: {
                        Image("info")
                            .foregroundStyle(Color(.green1))
                            .offset(y: -1)
                    }
                }
                Group {
                    Text(item.dateText)
                    Text(item.diagnosis.displayText)
                }
                .font(Font.OwnglyphMeetme.regular.font(size: 20))
                .foregroundStyle(Color.brown1)
            }
            .padding(.trailing, 30)
//            Spacer()
        }
        .frame(width: 350, height: 180)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(item.diagnosis.backgroundColor)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        )
    }
}

#Preview {
    let sample = PlantProfile(id: UUID(), name: "똥맛토", iconName: "tomato")
    let record = MedicalRecord(plantProfile: sample, dateText: "2025.09.03", diagnosis: .normal, plantId: 1, speciesId: 1)
    ListComponent(item: record, onInfoTap: {
        print("Preview info tap")
    })
}
