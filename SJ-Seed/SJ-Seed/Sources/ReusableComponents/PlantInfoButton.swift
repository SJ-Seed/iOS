//
//  PlantInfoButton.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/28/25.
//

import SwiftUI

struct PlantInfoButton: View {
    let name: String
    
    var body: some View {
        HStack {
            Text(name)
                .font(Font.OwnglyphMeetme.regular.font(size: 24))
                .foregroundStyle(Color.brown1)
            Button {
                print("info")
            } label: {
                Image(.info)
                    .foregroundStyle(Color(.brown1))
                    .offset(y: -1)
            }
        }
    }
}

#Preview {
    PlantInfoButton(name: "토마토")
}
