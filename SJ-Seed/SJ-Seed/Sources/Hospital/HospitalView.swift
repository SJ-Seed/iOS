//
//  HospitalView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/8/25.
//

import SwiftUI
import PhotosUI

struct HospitalView: View {
    let allProfiles: [PlantProfile] = [
            PlantProfile(id: UUID(), name: "토마토", iconName: "tomato"),
            PlantProfile(id: UUID(), name: "상추", iconName: "lettuce"),
            PlantProfile(id: UUID(), name: "바질", iconName: "basil")
        ]
    
    @State private var selectedProfile: PlantProfile
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePreview = false
    
    init() {
        _selectedProfile = State(initialValue: allProfiles[0])
    }
    var body: some View {
        ZStack {
            // 배경
            Image(.background)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ZStack(alignment: .top) {
                    CloudPlantComponent(bg: Image(.clearCircle), icon: selectedProfile.icon, size: 230)
                        .padding(.top, 50)
                    
                    PlantPicker(selected: $selectedProfile, plants: allProfiles)
                        .padding(.horizontal, 120)
                }
                
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Text("뚝딱! 진료받기")
                        .font(Font.OwnglyphMeetme.regular.font(size: 22))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding()
                        .background(.brown1)
                        .cornerRadius(20)
                }
//                .onChange(of: selectedItem) { oldValue, newValue in
//                    Task {
//                        if let data = try? await newValue?.loadTransferable(type: Data.self),
//                           let uiImage = UIImage(data: data) {
//                            selectedImage = uiImage
//                            showImagePreview = true
//                        }
//                    }
//                }
                
                CharacterSpeechComponent(
                    characterImage: .doctor1,
                    textString: "혹시 모르니\n진료 한 번 받아볼래?"
                )
                .padding(.top, 10)
            }
            .padding(.top, 100)
        }
//        .sheet(isPresented: $showImagePreview) {
//            if let image = selectedImage {
//                VStack {
//                    Text("\(selectedProfile.name) 진료 사진 미리보기")
//                        .font(Font.OwnglyphMeetme.regular.font(size: 22))
//                        .padding(.bottom, 10)
//                        .foregroundStyle(.brown1)
//                    
//                    Image(uiImage: image)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(maxWidth: .infinity)
//                        .cornerRadius(20)
//                        .padding()
//                    
//                    Button(action: { showImagePreview = false }) {
//                        Text("확인")
//                            .font(Font.OwnglyphMeetme.regular.font(size: 22))
//                            .foregroundStyle(.brown1)
//                    }
//                    .padding()
//                    .background(.brown1)
//                    .foregroundColor(.white)
//                    .cornerRadius(12)
//                }
//                .background(Color.ivory1)
//                .padding()
//            }
//        }
    }
}

#Preview {
    HospitalView()
}
