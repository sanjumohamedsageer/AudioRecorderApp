//
//  AudioRecordingService.swift
//  AudioRecorder
//
//  Created by Sanju K Mohamed Sageer on 25/05/26.
//

import Foundation
import AVFoundation
import Combine

final class AudioRecordingService: NSObject,
                                   ObservableObject,
                                   AudioRecordingServiceProtocol {
    
    @Published var currentAudioLevel: Float = 0
    
    private let repository = RecordingRepository()
    
    private var recorder: AVAudioRecorder?
    
    private var meterTimer: CADisplayLink?
    
    override init() {
        super.init()
        
        requestPermission()
    }
    
    private func requestPermission() {
        
        AVAudioApplication.requestRecordPermission{ granted in
            
            if !granted {
                print("Microphone permission denied")
            }
        }
    }
    
    func startRecording() async throws {
        
        let session = AVAudioSession.sharedInstance()
        
        try session.setCategory(
            .playAndRecord,
            mode: .default,
            options: [.defaultToSpeaker]
        )
        
        try session.setActive(true)
        
        let url = repository.saveURL()
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        recorder = try AVAudioRecorder(
            url: url,
            settings: settings
        )
        
        guard let recorder else {
            return
        }
        
        recorder.isMeteringEnabled = true
        
        recorder.prepareToRecord()
        
        recorder.record()
        
        startMetering()
    }
    
    
    func stopRecording() throws -> Recording {
        
        recorder?.stop()
        stopMetering()
        
        guard let url = recorder?.url else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        
        let asset = AVURLAsset(url: url)
        var seconds: Double = 0
        let semaphore = DispatchSemaphore(value: 0)
        
        Task {
            
            do {
                
                let duration = try await asset.load(.duration)
                seconds = CMTimeGetSeconds(duration)
                
            } catch {
                print(error.localizedDescription)
            }
            
            semaphore.signal()
        }
        
        semaphore.wait()
        
        return Recording(
            id: UUID(),
            fileURL: url,
            createdAt: Date(),
            duration: seconds
        )
    }
    
    func fetchRecordings() -> [Recording] {
        repository.fetchRecordings()
    }
    
    private func startMetering() {
        
        stopMetering()
        meterTimer = CADisplayLink(
            target: self,
            selector: #selector(updateMeter)
        )
        
        meterTimer?.preferredFramesPerSecond = 30
        meterTimer?.add(to: .main, forMode: .common)
    }
    
    private func stopMetering() {
        meterTimer?.invalidate()
        meterTimer = nil
    }
    
    @objc
    private func updateMeter() {
        
        guard let recorder else { return }
        
        recorder.updateMeters()
        let power = recorder.averagePower(forChannel: 0)
        let level = normalizedPowerLevel(from: power)
        DispatchQueue.main.async {
            self.currentAudioLevel = level
        }
    }
    
    private func normalizedPowerLevel(from decibels: Float) -> Float {
        
        if decibels < -60 {
            return 0.0
        }
        
        let level = pow(10.0, decibels / 20.0)
        
        return max(0.02, level)
    }
}
