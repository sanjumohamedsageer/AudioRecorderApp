//
//  RecordingRepository.swift
//  AudioRecorder
//
//  Created by Sanju K Mohamed Sageer on 25/05/26.
//

import Foundation
import AVFoundation

class RecordingRepository {
    let fileManager = FileManager.default
    var recordingDirectory:URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func saveURL() -> URL {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        
        let fileName = "Recording_\(formatter.string(from: Date())).m4a"
        return recordingDirectory.appendingPathComponent(fileName)
        
    }
    
    func fetchRecordings() -> [Recording] {
        
        guard let files = try? fileManager.contentsOfDirectory(
            at: recordingDirectory,
            includingPropertiesForKeys: nil
        ) else {
            return []
        }
        
        let audioFiles = files.filter {
            $0.pathExtension == "m4a"
        }
        
        return audioFiles.compactMap { url in
            
            let asset = AVURLAsset(url: url)
            var seconds: Double = 0
            let semaphore = DispatchSemaphore(value: 0)
            
            Task {
                
                do {
                    
                    let duration =
                    try await asset.load(.duration)
                    seconds = CMTimeGetSeconds(duration)
                    
                } catch {
                    print(error.localizedDescription)
                }
                
                semaphore.signal()
            }
            
            semaphore.wait()
            let creationDate = (
                try? url.resourceValues(
                    forKeys: [.creationDateKey]
                )
            )?.creationDate ?? Date()
            
            return Recording(
                id: UUID(),
                fileURL: url,
                createdAt: creationDate,
                duration: seconds
            )
            
        }.sorted { lhs, rhs in
            lhs.createdAt > rhs.createdAt
        }
    }
}


