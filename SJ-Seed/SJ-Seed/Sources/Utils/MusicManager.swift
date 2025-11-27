//
//  MusicManager.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/27/25.
//


import Foundation
import AVFoundation

final class MusicManager {
    static let shared = MusicManager()
    private var player: AVAudioPlayer?
    
    private init() {}
    
    func playMusic() {
        // 이미 재생 중이면 리턴
        if let player = player, player.isPlaying { return }
        
        // 파일 이름: "Lite Saturation - Piano.mp3" (확장자 제외)
        // 확장자: "mp3"
        // (파일 이름이 실제로 .mp3가 두 번 들어간다면 이름 부분을 수정해야 합니다)
        guard let url = Bundle.main.url(forResource: "Lite Saturation - Piano.mp3", withExtension: "mp3") else {
            print("❌ 음악 파일을 찾을 수 없습니다.")
            return
        }
        
        do {
            // 백그라운드 재생을 위한 세션 설정 (선택사항)
            // try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            // try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1 // 무한 반복
            player?.volume = 0.5 // 볼륨 조절 (0.0 ~ 1.0)
            player?.prepareToPlay()
            player?.play()
            print("🎵 음악 재생 시작")
        } catch {
            print("❌ 음악 재생 오류: \(error)")
        }
    }
    
    func stopMusic() {
        player?.stop()
        // player = nil // 필요하다면 초기화 (보통 stop만 해도 됨)
        print("🔇 음악 정지")
    }
}