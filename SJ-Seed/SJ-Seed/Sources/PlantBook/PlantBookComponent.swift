//
//  PlantBookComponent.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/29/25.
//

import SwiftUI

struct PlantBookComponent: View {
    var plant: PlantBookModel = PlantBookModel(id: UUID(), plant: PlantProfile(id: UUID(), name: "토마토", iconName: "tomato"), rarity: 2)
    
    var body: some View {
        VStack(spacing: 0) {
            CloudPlantComponent(bg: Image(.cloudCircle), icon: plant.plant.icon, size: 110)
                .padding(.bottom, 10)
            Text(plant.plant.name)
                .foregroundStyle(.green1)
                .font(Font.OwnglyphMeetme.regular.font(size: 28))
            
            HStack(spacing: 0) {
                ForEach(0..<plant.rarity, id: \.self) { _ in
                    Image(.star)
                }
            }
        }
    }
}

#Preview {
    PlantBookComponent()
}
