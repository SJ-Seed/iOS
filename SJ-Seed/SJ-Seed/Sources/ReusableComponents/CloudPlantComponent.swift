//
//  CloudPlantComponent.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/30/25.
//

import SwiftUI

struct CloudPlantComponent: View {
    var bg: Image = Image(.cloudCircle)
    let icon: Image
    var size: CGFloat = 130

    var body: some View {
        ZStack {
            bg.resizable()
                .frame(width: size, height: size)
            icon.resizable()
                .scaledToFit()
                .frame(width: size/1.8)
                .offset(y: 5)
        }
    }
}

#Preview {
    CloudPlantComponent(bg: Image(.clearCircle), icon: Image(.sprout))
}
