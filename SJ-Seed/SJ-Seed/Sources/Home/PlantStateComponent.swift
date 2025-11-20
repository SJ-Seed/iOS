//
//  PlantStateComponent.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/23/25.
//

import SwiftUI

struct PlantStateComponent: View {
    @StateObject var viewModel: PlantStateViewModel
    var onInfoTap: () -> Void
    var onWaterTap: () -> Void/* = {}*/
    
    init(
        viewModel: PlantStateViewModel = PlantStateViewModel(),
        onInfoTap: @escaping () -> Void = {},
        onWaterTap: @escaping () -> Void = {}
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onInfoTap = onInfoTap
        self.onWaterTap = onWaterTap
    }

    var body: some View {
        VStack(alignment: .leading) {
            BrownSpeechBubbleComponent(textString: viewModel.statusMessage)
            
            HStack(alignment: .top, spacing: 16) {
                PlantAvatarView(
                    icon: viewModel.plant.plantProfile.icon,
                    name: viewModel.plant.plantProfile.name,
                    onInfoTap: onInfoTap
                )
                VStack {
                    PlantVitalsView(vitals: viewModel.plant.vitals)
                    WaterActionButton(needsWater: viewModel.shouldWater) {
                        if viewModel.shouldWater {
                            onWaterTap()
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.top)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.ivory1)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        )
    }
}

struct PlantAvatarView: View {
    let icon: Image
    let name: String
    var onInfoTap: () -> Void = {}

    var body: some View {
        VStack {
            CloudPlantComponent(icon: icon)
            PlantInfoButton(name: name, action: onInfoTap)
        }
    }
}

struct PlantVitalsView: View {
    let vitals: PlantVitals

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VitalRow(title: "온도", value: "\(Int(vitals.temperature))℃")
            VitalRow(title: "습도", value: "\(Int(vitals.humidity))%")
            VitalRow(title: "토양", value: vitals.soil.rawValue)
        }
    }
}

struct VitalRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 8) {
            Text("\(title):")
                .font(Font.OwnglyphMeetme.regular.font(size: 24))
                .foregroundStyle(Color.brown1)
            Text(value)
                .font(Font.OwnglyphMeetme.regular.font(size: 24))
                .foregroundStyle(Color.brown1)
        }
    }
}

struct WaterActionButton: View {
    var needsWater: Bool
    var action: () -> Void = { }

    var body: some View {
        Button(action: action) {
            (needsWater ? Image(.watering) : Image(.nonwatering))
                .resizable()
                .frame(width: 130, height: 80)
                .shadow(radius: 2, y: 2)
                .padding(.bottom)
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    PlantStateComponent(
        viewModel: PlantStateViewModel(
            plant: PlantHomeInfo(
                plantProfile: .init(id: UUID(), name: "토마토", iconName: "tomato"),
                vitals: PlantVitals(temperature: 33, humidity: 65, soil: .dry)
            ),
            statusMessage: "덥고 목말라요 😣",
            shouldWater: true
        )
    )
}
