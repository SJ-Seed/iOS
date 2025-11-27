//
//  MyPageView.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/27/25.
//


import SwiftUI

struct MyPageView: View {
    @Environment(\.diContainer) private var di
    @StateObject private var viewModel = MyPageViewModel()
    
    var body: some View {
        ZStack {
            // 1. 배경
            Image("loginBG") // 배경 이미지 (LoginMainView와 동일한 것 사용 가정)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // 상단 헤더 (뒤로가기)
                HStack {
                    Button(action: { di.router.pop() }) {
                        Image("chevronLeft")
                            .foregroundStyle(.ivory1) // 배경이 어두우면 흰색, 아니면 .brown1
                            .padding(.leading)
                    }
                    Spacer()
                }
                .padding(.vertical, 50)
                .padding(.horizontal)
                
                // 2. 프로필 카드
                VStack(spacing: 10) {
                    HStack(spacing: 30) {
                        // 프로필 이미지 & 이름
                        VStack {
                            Image("profile") // 프로필 이미지
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding()
                                .background(Circle().fill(Color.white))
                            
                            Text(viewModel.userName)
                                .font(Font.OwnglyphMeetme.regular.font(size: 24))
                                .foregroundStyle(.brown1)
                        }
                        .padding()
//                        Spacer()
                        
                        // 통계 정보
                        VStack(alignment: .leading, spacing: 8) {
                            Text("식물 친구 \(viewModel.plantCount)그루")
                            Text("도감 조각 \(viewModel.pieceCount)개")
                        }
                        .font(Font.OwnglyphMeetme.regular.font(size: 20))
                        .foregroundStyle(.brown1)
                        
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 30)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.ivory1)
                            .shadow(radius: 5)
                    )
                }
//                .padding(.horizontal, 30)
                
                Spacer().frame(height: 10)
                
                // 3. 설정 버튼들
                VStack(spacing: 16) {
                    // 음악 설정 (Toggle)
                    HStack {
                        Text("음악")
                            .font(Font.OwnglyphMeetme.regular.font(size: 24))
                            .foregroundStyle(.brown1)
                        Spacer()
                        Toggle("", isOn: $viewModel.isMusicOn)
                            .toggleStyle(SwitchToggleStyle(tint: .brown1))
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.ivory1)
                            .strokeBorder(Color.brown1, lineWidth: 2)
                    )
                    
                    // 전화번호 설정하기 (Button)
                    Button(action: {
                        withAnimation {
                            viewModel.showPhoneInputModal = true
                        }
                    }) {
                        HStack {
                            Text("전화번호 설정하기")
                                .font(Font.OwnglyphMeetme.regular.font(size: 24))
                                .foregroundStyle(.brown1)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.brown1)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.ivory1)
                                .strokeBorder(Color.brown1, lineWidth: 2)
                        )
                    }
                    
                    // 프리미엄 멤버십 (Button)
                    Button(action: {
                        viewModel.showPremiumAlert = true
                    }) {
                        HStack {
                            Text("프리미엄 멤버십")
                                .font(Font.OwnglyphMeetme.regular.font(size: 24))
                                .foregroundStyle(.brown1)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.brown1)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.ivory1)
                                .strokeBorder(Color.brown1, lineWidth: 2)
                        )
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            
            // 4. 전화번호 입력 모달 (ZStack 최상단)
            if viewModel.showPhoneInputModal {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        viewModel.showPhoneInputModal = false
                    }
                
                PhoneNumberInputView(
                    currentNumber: viewModel.phoneNumber,
                    onSave: { newNumber in
                        viewModel.savePhoneNumber(newNumber)
                    },
                    onClose: {
                        viewModel.showPhoneInputModal = false
                    }
                )
            }
        }
        .alert("준비 중", isPresented: $viewModel.showPremiumAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text("아직 준비 중인 기능이에요.\n조금만 기다려주세요! 🚧")
        }
    }
}

#Preview {
    MyPageView()
}
