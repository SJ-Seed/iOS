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
        VStack {
            buttonImage
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 130, height: 170)
                .clipped()
            Text(buttonText)
                .font(Font.OwnglyphMeetme.regular.font(size: 28))
                .foregroundColor(.black)
        }
    }
}

#Preview {
    MainButtonComponent(buttonImage: Image(.student), buttonText: "도감")
}
