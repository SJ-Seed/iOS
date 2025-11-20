//
//  PlantStatePager.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/28/25.
//

import SwiftUI

struct PlantStatePager: View {
    let viewModels: [PlantStateViewModel]
    @State private var selection: Int = 0
    var onInfoTap: (Int) -> Void
    var onWaterTap: (Int) -> Void
    
    private var plantNames: [String] {
        viewModels.map { $0.plant.plantProfile.name }
    }
    
    @State private var isPickerExpanded = false
    
    var body: some View {
        VStack(spacing: 0) { // VStack으로 감싸서 상단 Picker 공간 확보
            // MARK: - 1. 상단 식물 목록 Picker
//            HStack {
//                Text("식물 목록")
//                    .font(Font.OwnglyphMeetme.regular.font(size: 24))
//                    .foregroundStyle(.brown1)
//                
//                // 현재 선택된 식물 이름 표시 & 드롭다운 버튼
//                Menu {
//                    ForEach(viewModels.indices, id: \.self) { index in
//                        Button {
//                            withAnimation {
//                                selection = index
//                            }
//                        } label: {
//                            HStack {
//                                Text(viewModels[index].plant.plantProfile.name)
//                                if selection == index {
//                                    Image(systemName: "checkmark")
//                                }
//                            }
//                        }
//                    }
//                } label: {
//                    HStack(spacing: 4) {
//                        Text(viewModels.isEmpty ? "" : viewModels[selection].plant.plantProfile.name)
//                            .font(Font.OwnglyphMeetme.regular.font(size: 20))
//                            .foregroundStyle(.brown1)
//                            .underline() // 선택 가능하다는 힌트
//                        
//                        Image(systemName: "chevron.down")
//                            .font(.system(size: 14, weight: .bold))
//                            .foregroundStyle(.brown1)
//                    }
////                    .padding(.vertical, 4)
//                    .padding(.horizontal, 8)
//                    .background(Color.ivory1.opacity(0.5))
//                    .cornerRadius(8)
//                }
//            }
//            .padding(.top, 15)
//            .zIndex(1) // Pager보다 위에 오도록 설정
            
            ZStack {
                // 스와이프 가능한 페이지
                TabView(selection: $selection) {
                    ForEach(viewModels.indices, id: \.self) { i in
                        PlantStateComponent(
                            viewModel: viewModels[i],
                            onInfoTap: { onInfoTap(viewModels[i].plantId) },
                            onWaterTap: { onWaterTap(viewModels[i].plantId) }
                        )
                        .padding(.horizontal, 25)
                        .tag(i)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // 좌우 화살표
                HStack {
                    // <
                    Button {
                        withAnimation(.easeInOut) { selection = max(selection - 1, 0) }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .opacity(selection > 0 ? 1 : 0.35)
                            .foregroundStyle(selection > 0 ? .brown1 : .clear)
                    }
                    .disabled(selection == 0)

                    Spacer()

                    // >
                    Button {
                        withAnimation(.easeInOut) { selection = min(selection + 1, viewModels.count - 1) }
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .semibold))
                            .opacity(selection < viewModels.count - 1 ? 1 : 0.35)
                            .foregroundStyle(selection < viewModels.count - 1 ? .brown1 : .clear)
                    }
                    .disabled(selection >= viewModels.count - 1)
                }
                .padding(.horizontal, 30)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.ivory1)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                .padding(.horizontal, 25)
                .frame(height: 330)
        )
    }
}
