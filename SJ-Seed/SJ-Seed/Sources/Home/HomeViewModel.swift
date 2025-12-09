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
    
    @Published var plantStateViewModels: [PlantStateViewModel] = []
    
    private let attendService = AttendService.shared
    private let plantService = PlantService.shared
    private let memberService = MemberService.shared
//    private let memberId = 1 // 임시 하드코딩
    private var memberId: Int {
        return AuthManager.shared.currentMemberId
    }
    
    // 1. ‼️ 저장 키 추가 (날짜 저장용, 금액 저장용)
    private let lastRewardDateKey = "lastRewardDateV1"
    private let lastRewardAmountKey = "lastRewardAmountV1"
    
    private var koreaCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        // "Asia/Seoul" 타임존 설정 (GMT+9)
        if let timeZone = TimeZone(identifier: "Asia/Seoul") {
            calendar.timeZone = timeZone
        }
        return calendar
    }
    
    init() {
        let isMusicOn = UserDefaults.standard.object(forKey: "isMusicOn") as? Bool ?? false
        if isMusicOn {
            MusicManager.shared.playMusic()
        }
        // 2. 앱 켜자마자: 저장된 데이터가 "오늘" 것이면 불러오기
        restoreTodayReward()
        
        // 3. API 호출
        performCheckIn(isInitialLoad: true)
        fetchMemberPlants()
    }
    
    // MARK: - 코인 조회
    func fetchCurrentCoin() {
        memberService.getCoin(memberId: memberId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let coin):
                self.coin = coin
                print("💰 현재 코인: \(coin)")
            case .failure(let error):
                print("❌ 코인 조회 실패:", error)
            }
        }
    }
    
    func refreshData() {
        // 새로고침 시에도 날짜 확인 (자정이 지났을 수 있으므로)
        restoreTodayReward()
        
        guard !isLoading else { return }
        performCheckIn(isInitialLoad: false)
        fetchMemberPlants()
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
        let today = koreaCalendar.startOfDay(for: Date())
        UserDefaults.standard.set(today, forKey: lastRewardDateKey)
        UserDefaults.standard.set(amount, forKey: lastRewardAmountKey)
    }
    
    // 6. ‼️ 저장된 보상을 복구하거나 초기화하는 함수
    private func restoreTodayReward() {
        let today = koreaCalendar.startOfDay(for: Date())
        if let lastDate = UserDefaults.standard.object(forKey: lastRewardDateKey) as? Date {
            if koreaCalendar.isDate(lastDate, inSameDayAs: today) {
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
    
    // MARK: - 내 식물 목록 조회 및 상태 업데이트
    func fetchMemberPlants() {
        // (식물 로딩은 전체 로딩에 포함시키지 않고 조용히 업데이트하거나 별도 로딩 표시)
        
        plantService.getMemberPlants(memberId: memberId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let plants):
                // API 응답([MemberPlantResult])을 [PlantStateViewModel]로 변환
                self.plantStateViewModels = plants.map { plantData in
                    self.createPlantViewModel(from: plantData)
                }
                
            case .failure(let error):
                print("❌ 내 식물 목록 로드 실패:", error)
                // (식물 로드 실패 시 에러 처리는 기획에 따라 추가)
            }
        }
    }
    
    // Helper: 개별 식물 데이터로 ViewModel 생성
    private func createPlantViewModel(from data: MemberPlantResult) -> PlantStateViewModel {
        
        // 1. 아이콘 찾기
        // (speciesId나 이름으로 PlantAssets에서 찾음)
        let speciesId = data.speciesId ?? 0
        let asset = PlantAssets.find(bySpeciesId: speciesId)
        let iconName = asset?.iconName ?? "sprout"
        
        // 2. 토양 상태 변환 (0~100 수분량 -> SoilMoistureLevel)
        // (임의의 기준: 30 미만 건조, 30~70 적정, 70 초과 과습)
        let soilLevel: SoilMoistureLevel
        if data.soilWater < 30 { soilLevel = .dry }
        else if data.soilWater > 70 { soilLevel = .wet }
        else { soilLevel = .normal }
        
        // 3. 기본 정보 구성
        let plantHomeInfo = PlantHomeInfo(
            plantProfile: PlantProfile(id: UUID(), name: data.name, iconName: iconName),
            vitals: PlantVitals(
                temperature: data.temperature,
                humidity: data.humidity,
                soil: soilLevel
            )
        )
        
        // 4. ViewModel 생성 (초기값)
        let viewModel = PlantStateViewModel(
            plantId: data.plantId,
            plant: plantHomeInfo,
            statusMessage: "상태를 확인 중이에요...", // 로딩 중 메시지
            shouldWater: false // 일단 false로 시작
        )
        
        // 5. ‼️ 물주기 필요 여부 API 호출 (비동기 업데이트)
//        plantService.checkIfNeedWater(plantId: data.plantId) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let needWater):
//                    viewModel.shouldWater = needWater
//                    // 물주기 필요 여부에 따라 상태 메시지 업데이트
////                    viewModel.statusMessage = needWater ? "목말라요 💦" : "기분이 좋아요 🌿"
//                    
//                case .failure:
//                    viewModel.statusMessage = "상태를 알 수 없어요 😢"
//                }
//            }
//        }
        
        return viewModel
    }
}
