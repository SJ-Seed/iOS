//
//  DocumentComponent.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/30/25.
//

import SwiftUI

struct DocumentComponent: View {
    var body: some View {
        HStack {
//            Spacer()
            CloudPlantComponent(icon: Image(.sprout))
                .padding()
                .padding(.trailing, 30)
//            Spacer()
            VStack(alignment: .leading) {
                HStack {
                    Text("토마토")
                        .font(Font.OwnglyphMeetme.regular.font(size: 30))
                        .foregroundStyle(Color.green1)
                    Button {
                        print("info")
                    } label: {
                        Image("info")
                            .foregroundStyle(Color(.green1))
                            .offset(y: -1)
                    }
                }
                Group {
                    Text("2025.09.03")
                    Text("정상")
                }
                .font(Font.OwnglyphMeetme.regular.font(size: 20))
            }
            .padding(.trailing, 30)
//            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.ivory1)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        )
    }
}

#Preview {
    DocumentComponent()
}
