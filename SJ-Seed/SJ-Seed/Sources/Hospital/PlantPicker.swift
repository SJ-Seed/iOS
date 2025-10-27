//
//  PlantPicker.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/8/25.
//

import SwiftUI

struct PlantPicker: View {
    @Binding var selected: PlantProfile
    let plants: [PlantProfile]
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(spacing: 8) {
            Button {
                withAnimation(.easeInOut(duration: 0.18)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 12) {
                    Text(selected.name)
                        .font(Font.OwnglyphMeetme.regular.font(size: 24))
                        .foregroundStyle(Color.brown1)
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.brown1)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            // 옵션 리스트
            if isExpanded {
                VStack(spacing: 6) {
                    ForEach(plants) { p in
                        Button {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                selected = p
                                isExpanded = false
                            }
                        } label: {
                            HStack(spacing: 12) {
                                p.icon
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                
                                Text(p.name)
                                    .font(Font.OwnglyphMeetme.regular.font(size: 18))
                                    .foregroundStyle(p.id == selected.id ? Color.brown1 : Color(.systemGray))
                                
                                Spacer()
                                
                                if p.id == selected.id {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(Color.brown1)
                                }
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 4)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.ivory1)
                        .strokeBorder(lineWidth: 2)
                        .foregroundStyle(Color.brown1)
                        .shadow(color: .black.opacity(0.04), radius: 1, x: 0, y: 1)
                )
            }
        }
    }
}

// MARK: - Preview helper
struct PlantPicker_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var selected = PlantProfile(id: UUID(), name: "토마토", iconName: "tomato")
        private let plants: [PlantProfile] = [
            PlantProfile(id: UUID(), name: "토마토", iconName: "tomato"),
            PlantProfile(id: UUID(), name: "상추", iconName: "lettuce"),
            PlantProfile(id: UUID(), name: "바질", iconName: "basil")
        ]

        var body: some View {
            PlantPicker(selected: $selected, plants: plants)
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
