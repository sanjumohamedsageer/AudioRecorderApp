//
//  AudioSessionManager.swift
//  AudioRecorder
//
//  Created by Sanju K Mohamed Sageer on 25/05/26.
//

import AVFoundation

class AudioSessionManager {
    static let shared = AudioSessionManager()
    
    private init() {}
    
    func configure() {
        do {
            let session = AVAudioSession.sharedInstance()
            
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try session.setActive(true)
        }catch {
            print(error.localizedDescription)
        }
    }
}

