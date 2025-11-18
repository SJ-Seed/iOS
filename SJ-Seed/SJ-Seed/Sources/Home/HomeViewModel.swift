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
    private let memberId = 2 // 임시 하드코딩
    
    // 1. ‼️ "마지막 보상 날짜"를 저장할 UserDefaults 키
    private let lastRewardDateKey = "lastRewardDateV1"
    
    init() {
        // 2. ‼️ ViewModel이 생성될 때, 날짜가 바뀌었는지 확인
        checkAndResetRewardIfNeeded()
        // 3. ‼️ '출석 체크 및 정보'를 한 번에 가져옴
        performCheckIn(isInitialLoad: true)
    }
    
    /**
     * 앱이 포그라운드로 돌아올 때 호출될 새로고침 함수
     */
    func refreshData() {
        // 4. ‼️ 새로고침 시에도 날짜가 바뀌었는지 확인
        checkAndResetRewardIfNeeded()
        
        // 이미 로딩 중이 아니라면 조용히 새로고침 (스피너 X)
        guard !isLoading else { return }
        performCheckIn(isInitialLoad: false)
    }
    
    /**
     * 출석 체크 (PATCH)
     * 이 함수가 로드 시 모든 데이터를 가져온다고 가정
     */
    func performCheckIn(isInitialLoad: Bool) {
        if isInitialLoad {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        attendService.checkIn(memberId: memberId) { [weak self] result in
            guard let self = self else { return }
            if isInitialLoad {
                self.isLoading = false // 로딩 종료
            }
            
            switch result {
            case .success(let data): // 'data'는 'AttendanceResult'
                print("✅ 출석 체크/조회 성공")
                
                let days = Weekday.allCases.enumerated().map { (index, weekday) in
                    let isChecked = (index < data.attendedDays.count) ? data.attendedDays[index] : false
                    return AttendanceDay(weekday: weekday, isChecked: isChecked)
                }
                
                // 5. ‼️ 출석일과 총 코인은 항상 업데이트
                self.attendance.days = days
                self.coin = data.totalCoin
                
                // 6. ‼️ "오늘의 보상"은 0이 아닌 값을 받았을 때만 덮어쓴다.
                if data.rewardedCoin != 0 {
                    self.attendance.todayRewardCoin = data.rewardedCoin
                    
                    // 7. ‼️ "오늘" 보상을 받았다고 UserDefaults에 저장
                    let today = Calendar.current.startOfDay(for: Date())
                    UserDefaults.standard.set(today, forKey: self.lastRewardDateKey)
                }
                // (만약 0을 받으면, self.attendance.todayRewardCoin의 기존 값을 유지)
                
            case .failure(let error):
                print("❌ HomeView 데이터 로드 실패 (checkIn):", error)
                if isInitialLoad {
                    self.errorMessage = "정보를 불러오지 못했어요 😢"
                }
            }
        }
    }
    
    /**
     * ‼️ 날짜가 바뀌었는지 확인하고, 바뀌었다면 보상 코인을 0으로 리셋하는 함수
     */
    private func checkAndResetRewardIfNeeded() {
        let today = Calendar.current.startOfDay(for: Date())
        
        // 마지막으로 보상받은 날짜를 불러옴
        if let lastRewardDate = UserDefaults.standard.object(forKey: lastRewardDateKey) as? Date {
            
            // 마지막 보상 날짜가 '오늘'이 아니라면 (즉, 날이 바뀌었다면)
            if !Calendar.current.isDate(lastRewardDate, inSameDayAs: today) {
                print("ℹ️ 날짜가 변경되었습니다. 오늘 보상을 0으로 리셋합니다.")
                self.attendance.todayRewardCoin = 0
            }
        }
    }
}
