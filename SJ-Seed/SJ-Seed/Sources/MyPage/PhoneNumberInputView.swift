//
//  PhoneNumberInputView.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/27/25.
//

import SwiftUI

// MARK: - 전화번호 입력 팝업 뷰
struct PhoneNumberInputView: View {
    @State var inputNumber: String
    var onSave: (String) -> Void
    var onClose: () -> Void
    
    init(currentNumber: String, onSave: @escaping (String) -> Void, onClose: @escaping () -> Void) {
        _inputNumber = State(initialValue: currentNumber)
        self.onSave = onSave
        self.onClose = onClose
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // 닫기 버튼 (X)
            HStack {
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.brown1)
                }
            }
            
            // 입력 필드
            TextField("전화번호를 입력하세요.", text: $inputNumber)
                .font(Font.OwnglyphMeetme.regular.font(size: 20))
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            
            // 확인 버튼
            Button(action: {
                onSave(inputNumber)
            }) {
                Text("확인")
                    .font(Font.OwnglyphMeetme.regular.font(size: 22))
                    .foregroundStyle(.ivory1)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.brown1)
                    .cornerRadius(30)
            }
        }
        .padding(25)
        .background(Color.ivory1) // 팝업 배경색
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.brown1, lineWidth: 2)
        )
        .padding(.horizontal, 40)
        .shadow(radius: 10)
    }
}
