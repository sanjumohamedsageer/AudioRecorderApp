//
//  RecorderViewModel.swift
//  AudioRecorder
//
//  Created by Sanju K Mohamed Sageer on 26/05/26.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation
import UIKit

@MainActor
final class RecorderViewModel: ObservableObject {
    
    @Published var isRecording = false
    @Published var recordings: [Recording] = []
    @Published var waveformSamples: [CGFloat] = Array(
        repeating: 8,
        count: AppConstants.waveformSampleCount
    )
    
    @Published var showSavedPopup = false
    @Published var savedRecordingName = ""
    @Published var currentlyPlayingID: UUID?
    @Published var showRenameAlert = false
    @Published var renameText = ""
    @Published var selectedRecording: Recording?
    @Published var searchText = ""
    @Published var permissionState: PermissionState = .unknown
    @Published var recordingDuration: TimeInterval = 0
    
    let playbackService = AudioPlaybackService()
    private let service: AudioRecordingService
    private var recordingTimer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    var playbackProgress: Double {
        
        guard playbackService.duration > 0 else {
            return 0
        }
        
        return playbackService.currentTime /
        playbackService.duration
    }
    
    var currentPlaybackTime: TimeInterval {
        playbackService.currentTime
    }
    
    var playbackDuration: TimeInterval {
        playbackService.duration
    }
    
    var filteredRecordings: [Recording] {
        
        if searchText.isEmpty {
            return recordings
        }
        
        return recordings.filter {
            
            $0.fileName
                .localizedCaseInsensitiveContains(
                    searchText
                )
        }
    }
    
    init(
        service: AudioRecordingService = AudioRecordingService()
    ) {
        
        self.service = service
        observeAudioLevels()
        loadRecordings()
        checkMicrophonePermission()
        observePlaybackState()
    }
    
    func toggleRecording() {
        
        HapticManager.shared.impact()
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        
        Task {
            
            do {
                
                try await service.startRecording()
                withAnimation(.spring()) {
                    isRecording = true
                }
                recordingDuration = 0
                startRecordingTimer()
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func stopRecording() {
        
        do {
            
            let recording = try service.stopRecording()
            recordings.insert(recording, at: 0)
            stopRecordingTimer()
            waveformSamples = Array(
                repeating: 8,
                count: AppConstants.waveformSampleCount
            )
            
            withAnimation(.spring()) {
                isRecording = false
            }
            savedRecordingName = recording.fileName
            withAnimation(.spring()) {
                showSavedPopup = true
            }
            
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 2
            ) {
                
                withAnimation(.easeOut) {
                    self.showSavedPopup = false
                }
            }
            
            HapticManager.shared.impact()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func togglePlayback(for recording: Recording) {
        
        let isCurrentRecording =
        playbackService.currentlyPlayingURL ==
        recording.fileURL

        if isCurrentRecording {
            
            if playbackService.isPlaying {
    
                playbackService.pausePlayback()
                
            } else {
                
                playbackService.resumePlayback()
            }
            
        } else {
            
            playbackService.stopPlayback()
            
            playbackService.startPlayback(
                url: recording.fileURL
            )
        }
    }
    
    func seekPlayback(to value: Double) {
        
        let targetTime =
        value * playbackService.duration
        playbackService.seek(to: targetTime)
    }
    
    private func observePlaybackState() {
        
        playbackService.$currentlyPlayingURL
            .receive(on: DispatchQueue.main)
            .sink { [weak self] url in
                
                if url == nil {
                    self?.currentlyPlayingID = nil
                }
            }
            .store(in: &cancellables)
    }
    
    private func observeAudioLevels() {
        
        service.$currentAudioLevel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] level in
                
                guard let self else { return }
                
                let normalized = max(
                    8,
                    CGFloat(level) * 300
                )
                
                self.waveformSamples.append(normalized)
                
                if self.waveformSamples.count >
                    AppConstants.waveformSampleCount {
                    
                    self.waveformSamples.removeFirst()
                }
            }
            .store(in: &cancellables)
    }
    
    private func loadRecordings() {
        recordings = service.fetchRecordings()
    }
    
    func deleteRecording(_ recording: Recording) {
        
        do {
            
            if FileManager.default.fileExists(
                atPath: recording.fileURL.path
            ) {
                
                try FileManager.default.removeItem(
                    at: recording.fileURL
                )
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        withAnimation {
            
            recordings.removeAll {
                $0.id == recording.id
            }
        }
        
        HapticManager.shared.impact()
    }
    
    func prepareRename(for recording: Recording) {
        
        selectedRecording = recording
        renameText = recording.fileName
        showRenameAlert = true
    }
    
    func renameRecording() {
        
        guard let recording = selectedRecording else {
            return
        }
        
        let cleanedName =
        renameText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        guard !cleanedName.isEmpty else {
            return
        }
        
        let directory =
        recording.fileURL.deletingLastPathComponent()
        
        let newURL =
        directory.appendingPathComponent(
            "\(cleanedName).m4a"
        )
        
        do {
            
            try FileManager.default.moveItem(
                at: recording.fileURL,
                to: newURL
            )
            
            loadRecordings()
            HapticManager.shared.impact()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func checkMicrophonePermission() {
        
        switch AVAudioApplication.shared.recordPermission {
            
        case .granted:
            
            permissionState = .granted
            
        case .denied:
            
            permissionState = .denied
            
        case .undetermined:
            
            AVAudioApplication.requestRecordPermission {
                granted in
                
                DispatchQueue.main.async {
                    
                    self.permissionState =
                    granted
                    ? .granted
                    : .denied
                }
            }
            
        @unknown default:
            
            permissionState = .denied
        }
    }
    
    func openSettings() {
        
        guard let url = URL(
            string: UIApplication.openSettingsURLString
        ) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    private func startRecordingTimer() {
        
        stopRecordingTimer()
        recordingDuration = 0
        recordingTimer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { [weak self] _ in
            
            Task { @MainActor in
                
                guard let self else { return }

                self.recordingDuration += 1
            }
        }
    }
    
    private func stopRecordingTimer() {
        
        recordingTimer?.invalidate()
        recordingTimer = nil
    }
}
