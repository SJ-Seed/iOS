//
//  PlantBookComponent.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/29/25.
//

import SwiftUI

struct PlantBookComponent: View {
    var plant: PlantBookModel = PlantBookModel(id: UUID(), plant: PlantProfile(id: UUID(), name: "토마토", iconName: "tomato"), rarity: 2, speciesId: 0)
    
    var body: some View {
        VStack(spacing: 0) {
            CloudPlantComponent(bg: Image(.cloudCircle), icon: plant.plant.icon, size: 110)
                .padding(.bottom, 10)
            Text(plant.plant.name)
                .foregroundStyle(.green1)
                .font(Font.OwnglyphMeetme.regular.font(size: 28))
            
            if plant.rarity > 0 {
                HStack(spacing: 0) {
                    ForEach(0..<plant.rarity, id: \.self) { _ in
                        Image(.star)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 20, height: 20)
                    }
                }
                .frame(height: 24)
            } else {
                // rarity == 0 → 별 없을 때도 동일 높이 확보
                Color.clear
                    .frame(height: 24)
            }
        }
    }
}

#Preview {
    PlantBookComponent()
}
