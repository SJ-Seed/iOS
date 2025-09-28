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

    var body: some View {
        ZStack {
            // 스와이프 가능한 페이지
            TabView(selection: $selection) {
                ForEach(viewModels.indices, id: \.self) { i in
                    PlantStateComponent(viewModel: viewModels[i])
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
}
