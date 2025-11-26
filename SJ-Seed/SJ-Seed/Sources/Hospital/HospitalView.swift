//
//  HospitalView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/8/25.
//

import SwiftUI
import PhotosUI

struct HospitalView: View {
    @Environment(\.diContainer) private var di
    
    @StateObject private var viewModel = HospitalViewModel()
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePreview = false
    @State private var showExampleModal = false
    
    var body: some View {
        if viewModel.isDiagnosisLoading {
            HospitalLoadingView()
        } else {
            ZStack {
                contentView
                if showExampleModal {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture { showExampleModal = false } // 배경 누르면 닫기
                    
                    examplePhoto
                        .padding(40)
                        .transition(.scale)
                }
            }
        }
    }
    
    var contentView: some View {
        ZStack {
            // 배경
            Image(.background)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Button(action: { di.router.pop() }) {
                        Image("chevronLeft")
                            .foregroundStyle(.ivory1)
                            .padding(.leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    Spacer()
                    Button(action: { di.router.push(.diagnosisList)}) {
                        Image("hospitalList")
                            .padding(.trailing, 32)
                    }
                }
                if viewModel.selectedImage == nil {
                    // --- 1. 상단 식물 선택 영역 (이미지 없을 때만 보임) ---
                    ZStack(alignment: .top) {
                        CloudPlantComponent(bg: Image(.clearCircle), icon: viewModel.selectedPlant.icon, size: 230)
                            .padding(.top, 50)
                        
                        if !viewModel.userPlants.isEmpty {
                            PlantPicker(
                                selected: $viewModel.selectedPlant,
                                plants: viewModel.userPlants
                            )
                            .padding(.horizontal, 120)
                        } else if viewModel.isLoading && viewModel.userPlants.isEmpty {
                            Text("로딩 중...")
                                .font(Font.OwnglyphMeetme.regular.font(size: 20))
                                .foregroundStyle(.brown1)
                                .padding(.top, 20)
                        }
                    }
                }
                
                if let image = viewModel.selectedImage {
                    // MARK: - 1. 이미지가 선택된 상태
                    VStack(spacing: 16) {
                        // 선택된 이미지 미리보기
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 285, height: 285)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(radius: 3)
                            // X 버튼 (선택 취소)
                            .overlay(alignment: .topTrailing) {
                                Button {
                                    viewModel.selectedImage = nil
                                    viewModel.selectedItems = []
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.white, .gray)
                                        .font(.title2)
                                        .padding(8)
                                }
                            }
                        
                        // 진짜 API 호출 버튼
                        Button {
                            viewModel.requestDiagnosis()
                        } label: {
                            Text("뚝딱! 진료 받기")
                                .font(Font.OwnglyphMeetme.regular.font(size: 24))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 12)
                        .background(Color.brown1)
                        .cornerRadius(20)
                    }
                    
                } else {
                    Button {
                        withAnimation {
                            showExampleModal = true
                        }
                    } label: {
                        Text("사진 업로드하기")
                            .font(Font.OwnglyphMeetme.regular.font(size: 24))
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 12)
                            .background(.brown1)
                            .cornerRadius(20)
                    }
                    // MARK: - 2. 이미지가 선택되지 않은 상태 (기본)
//                    PhotosPicker(
//                        selection: $viewModel.selectedItems, // 배열 바인딩
//                        maxSelectionCount: 1, // 1장만 선택 가능 (API 제한)
//                        matching: .images
//                    ) {
//                        Text("사진 업로드하기")
//                            .font(Font.OwnglyphMeetme.regular.font(size: 24))
//                            .foregroundColor(.white)
//                            .padding(.horizontal, 40)
//                            .padding(.vertical, 12)
//                            .background(.brown1)
//                            .cornerRadius(20)
//                    }
//                    .onChange(of: viewModel.selectedItems) { _, _ in
//                        viewModel.loadSelectedImage()
//                    }
                }
                CharacterSpeechComponent(
                    characterImage: .doctor1,
                    textString: "혹시 모르니\n진료 한 번 받아볼래?"
                )
                .padding(.top, 10)
                
                if let error = viewModel.errorMessage { let _ = print(error) }
            }
        }
        .task {
            viewModel.fetchUserPlants()
            viewModel.onDiagnosisComplete = { result in
                di.router.push(.diagnosisResult(plant: viewModel.selectedPlant, result: result))
            }
        }
        .onChange(of: viewModel.selectedItems) { _, _ in
            viewModel.loadSelectedImage()
        }
    }
    
    var examplePhoto: some View {
        VStack {
            Text("정확한 진단을 위해\n사진처럼 잎이 잘 보이게 촬영해줘!\n(어둡지 않고, 선명하게!)")
                .font(Font.OwnglyphMeetme.regular.font(size: 22))
                .multilineTextAlignment(.center)
                .foregroundStyle(.brown1)
            Image(.examplePhoto)
                .resizable()
                .scaledToFit()
                .frame(height: 180)
                .padding(.vertical)
            PhotosPicker(
                selection: $viewModel.selectedItems,
                maxSelectionCount: 1,
                matching: .images
            ) {
                Text("확인했어요!")
                    .font(Font.OwnglyphMeetme.regular.font(size: 24))
                    .foregroundColor(.white)
                    .padding(.horizontal, 85)
                    .padding(.vertical, 12)
                    .background(Color.brown1)
                    .cornerRadius(30)
            }
        }
        .padding(30)
        .padding(.vertical, 15)
        .background(.ivory1)
        .cornerRadius(30)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .strokeBorder(Color.brown1, lineWidth: 2)
        )
        .onChange(of: viewModel.selectedItems) { _, newItems in
            if !newItems.isEmpty {
                withAnimation {
                    showExampleModal = false
                }
            }
        }
    }
}

#Preview {
    HospitalView()
}
