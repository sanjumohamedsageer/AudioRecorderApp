//
//  AudioPlaybackService.swift
//  AudioRecorder
//
//  Created by Sanju K Mohamed Sageer on 25/05/26.
//


import Foundation
import AVFoundation
import Combine

final class AudioPlaybackService: NSObject,
                                  ObservableObject,
                                  AVAudioPlayerDelegate {
    
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 1
    @Published var currentlyPlayingURL: URL?
    
    private var player: AVAudioPlayer?
    private var timer: CADisplayLink?
    
    func startPlayback(url: URL) {
        
        do {
            
            stopPlayback()
            
            let audioPlayer = try AVAudioPlayer(
                contentsOf: url
            )
            
            player = audioPlayer
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.currentTime = 0
            currentTime = 0
            duration = audioPlayer.duration
            currentlyPlayingURL = url
            audioPlayer.play()
            isPlaying = true
            startTimer()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func pausePlayback() {
        player?.pause()
        isPlaying = false
        stopTimer()
    }
    
    func resumePlayback() {
        
        guard let player else { return }
        if player.currentTime >= player.duration {
            player.currentTime = 0
        }

        player.play()
        isPlaying = true
        startTimer()
    }
    
    func stopPlayback() {
        
        player?.stop()
        player = nil
        isPlaying = false
        currentTime = 0
        currentlyPlayingURL = nil
        stopTimer()
    }
    
    func seek(to value: TimeInterval) {
        
        guard let player else { return }
        
        player.currentTime = value
        currentTime = value
    }
    
    private func startTimer() {
        
        stopTimer()
        timer = CADisplayLink(
            target: self,
            selector: #selector(updateProgress)
        )
        
        timer?.preferredFramesPerSecond = 30
        timer?.add(
            to: .main,
            forMode: .common
        )
    }
    
    private func stopTimer() {
        
        timer?.invalidate()
        timer = nil
    }
    
    @objc
    private func updateProgress() {
        
        guard let player else {
            print("NO PLAYER")
            return
        }
        
        currentTime = player.currentTime
        if player.currentTime >= player.duration {
            stopPlayback()
        }
    }
    
    func audioPlayerDidFinishPlaying(
        _ player: AVAudioPlayer,
        successfully flag: Bool
    ) {
        stopPlayback()
    }
}
