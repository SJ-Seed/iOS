//
//  PlantPicker.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/8/25.
//


import SwiftUI

/// 드롭다운으로 식물 선택하는 컴포넌트
struct PlantPicker: View {
    @Binding var selected: PlantProfile
    let plants: [PlantProfile]

    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(spacing: 8) {
            // 헤더: 선택된 식물 표시 (아이콘 + 이름 + 화살표)
            Button {
                withAnimation(.easeInOut(duration: 0.18)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 12) {
//                    selected.icon
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 44, height: 44)

                    Text(selected.name)
                        .font(Font.OwnglyphMeetme.regular.font(size: 24))
                        .foregroundStyle(Color.brown1)

//                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.brown1)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
//            .background(
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(Color.ivory1)
//                    .strokeBorder(lineWidth: 2)
//                    .foregroundStyle(Color.brown1)
//                    .shadow(color: .black.opacity(0.06), radius: 1, x: 0, y: 1)
//                    .opacity(0.6)
//            )

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
                                    Image(systemName: "checkmark.circle.fill")
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
//                        .opacity(0.6)
                )
            }
        }
    }
}

// MARK: - Preview helper (래퍼로 State 관리)
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
