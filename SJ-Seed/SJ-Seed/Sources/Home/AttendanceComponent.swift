//
//  AttendanceComponent.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/23/25.
//

import SwiftUI

struct AttendanceComponent: View {
    let thisWeekAttendance: [Attendance] = Weekday.allCases.map {
        Attendance(weekday: $0, isChecked: true)
    }

    var body: some View {
        HStack {
            Image(.flower)
                .resizable()
                .frame(width: 40, height: 50)
                .padding(.leading)
            
            VStack(alignment: .leading) {
                Text("오늘의 출석: 50코인 지급 완료")
                    .font(Font.OwnglyphMeetme.regular.font(size: 24))
                    .foregroundStyle(Color(.brown1))
                HStack {
                    ForEach(thisWeekAttendance, id: \.weekday) { att in
                        Circle()
                            .fill(att.isChecked ? Color.yellow1 : Color.gray1)
                            .overlay(
                                Text(att.weekday.symbol)
                                    .font(Font.OwnglyphMeetme.regular.font(size: 20))
                                    .foregroundStyle(att.isChecked ? Color.yellow2 : Color.gray2)
                            )
                            .overlay(
                                Circle()
                                    .stroke(att.isChecked ? Color.yellow2 : .clear, lineWidth: 2)
                            )
                    }
                }
            }
            .padding()
            .padding(.vertical, 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.ivory1)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        )
    }
}

#Preview {
    AttendanceComponent()
}
