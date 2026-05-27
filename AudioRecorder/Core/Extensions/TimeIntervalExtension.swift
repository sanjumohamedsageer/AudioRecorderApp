//
//  TimeIntervalExtension.swift
//  AudioRecorder
//
//  Created by Sanju K Mohamed Sageer on 26/05/26.
//

import Foundation

extension TimeInterval {
    
    func formattedTime() -> String {
        
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        
        return String(
            format: "%02d:%02d",
            minutes,
            seconds
        )
    }
}

