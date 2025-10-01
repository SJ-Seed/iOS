//
//  CloudPlantComponent.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/30/25.
//

import SwiftUI

struct CloudPlantComponent: View {
    let icon: Image
    var size: CGFloat = 130

    var body: some View {
        ZStack {
            Image(.cloudCircle)
                .resizable()
                .frame(width: size, height: size)
            icon
        }
    }
}

#Preview {
    CloudPlantComponent(icon: Image(.sprout))
}
