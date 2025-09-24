//
//  MainButtonComponent.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/15/25.
//

import SwiftUI

struct MainButtonComponent: View {
    var buttonImage: Image
    var buttonText: String
    
    var body: some View {
        Button(action: {
            print("\(buttonText) tapped")
        }) {
            VStack {
                buttonImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 110, height: 150)
                
                Text(buttonText)
                    .font(Font.OwnglyphMeetme.regular.font(size: 28))
                    .foregroundColor(.brown1)
            }
        }
    }
}

#Preview {
    MainButtonComponent(buttonImage: Image(.student), buttonText: "도감")
}
