//
//  AudioRecordingServiceProtocol.swift
//  AudioRecorder
//
//  Created by Sanju K Mohamed Sageer on 25/05/26.
//

import Foundation


protocol AudioRecordingServiceProtocol {
    
    var currentAudioLevel: Float { get }
    func startRecording() async throws
    func stopRecording() throws -> Recording
    func fetchRecordings() -> [Recording]
}
