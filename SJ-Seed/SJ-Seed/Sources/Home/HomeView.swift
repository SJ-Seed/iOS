//
//  HomeView.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/15/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
            VStack {
                Spacer()
                HStack {
                    MainButtonComponent(buttonImage: Image(.student), buttonText: "도감")
                    MainButtonComponent(buttonImage: Image(.grandma2), buttonText: "식물")
                    MainButtonComponent(buttonImage: Image(.doctor), buttonText: "병원")
                }
                .padding(.bottom, 30)
            }
        }
    }
}

#Preview {
    HomeView()
}
