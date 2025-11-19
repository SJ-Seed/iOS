//
//  HomeViewModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/18/25.
//

import Foundation
import Combine
import UIKit

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published var coin: Int = 0
    @Published var attendance = WeeklyAttendance()
    @Published var isLoading = true
    @Published var errorMessage: String? = nil
    
    private let attendService = AttendService.shared
    private let memberId = 1 // 임시 하드코딩
    
    // 1. ‼️ 저장 키 추가 (날짜 저장용, 금액 저장용)
    private let lastRewardDateKey = "lastRewardDateV1"
    private let lastRewardAmountKey = "lastRewardAmountV1" // 👈 추가됨
    
    init() {
        // 2. ‼️ 앱 켜자마자: 저장된 데이터가 "오늘" 것이면 불러오기
        restoreTodayReward()
        
        // 3. API 호출
        performCheckIn(isInitialLoad: true)
    }
    
    func refreshData() {
        // 새로고침 시에도 날짜 확인 (자정이 지났을 수 있으므로)
        restoreTodayReward()
        
        guard !isLoading else { return }
        performCheckIn(isInitialLoad: false)
    }
    
    func performCheckIn(isInitialLoad: Bool) {
        if isInitialLoad {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        attendService.checkIn(memberId: memberId) { [weak self] result in
            guard let self = self else { return }
            if isInitialLoad {
                self.isLoading = false
            }
            
            switch result {
            case .success(let data):
                print("✅ 출석 체크/조회 성공: 받은 코인 \(data.rewardedCoin)")
                
                let days = Weekday.allCases.enumerated().map { (index, weekday) in
                    let isChecked = (index < data.attendedDays.count) ? data.attendedDays[index] : false
                    return AttendanceDay(weekday: weekday, isChecked: isChecked)
                }
                
                self.attendance.days = days
                self.coin = data.totalCoin
                
                // 4. ‼️ 0이 아닌 값을 받았을 때만 저장하고 화면 갱신
                if data.rewardedCoin != 0 {
                    self.attendance.todayRewardCoin = data.rewardedCoin
                    self.saveTodayReward(amount: data.rewardedCoin) // 👈 저장 함수 호출
                }
                // (0을 받으면, 'restoreTodayReward'로 복구해둔 기존 값을 유지)
                
            case .failure(let error):
                print("❌ HomeView 데이터 로드 실패:", error)
                if isInitialLoad {
                    self.errorMessage = "정보를 불러오지 못했어요 😢"
                }
            }
        }
    }
    
    // MARK: - 로컬 저장소(UserDefaults) 로직
    
    // 5. ‼️ 오늘 받은 보상을 저장하는 함수
    private func saveTodayReward(amount: Int) {
        let today = Calendar.current.startOfDay(for: Date())
        UserDefaults.standard.set(today, forKey: lastRewardDateKey)
        UserDefaults.standard.set(amount, forKey: lastRewardAmountKey)
    }
    
    // 6. ‼️ 저장된 보상을 복구하거나 초기화하는 함수
    private func restoreTodayReward() {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let lastDate = UserDefaults.standard.object(forKey: lastRewardDateKey) as? Date {
            if Calendar.current.isDate(lastDate, inSameDayAs: today) {
                // 날짜가 오늘과 같음 -> 저장된 금액 불러오기 (예: 20)
                let savedAmount = UserDefaults.standard.integer(forKey: lastRewardAmountKey)
                self.attendance.todayRewardCoin = savedAmount
                print("💾 저장된 오늘 보상(\(savedAmount))을 복구했습니다.")
            } else {
                // 날짜가 다름 (어제 기록) -> 0으로 초기화
                self.attendance.todayRewardCoin = 0
                print("ℹ️ 날짜가 변경되어 보상을 0으로 리셋했습니다.")
            }
        } else {
            // 기록 없음
            self.attendance.todayRewardCoin = 0
        }
    }
}
