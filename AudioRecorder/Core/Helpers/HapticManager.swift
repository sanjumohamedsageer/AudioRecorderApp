//
//  HapticManager.swift
//  AudioRecorder
//
//  Created by Sanju K Mohamed Sageer on 25/05/26.
//

import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    func impact() {
       let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
    }
}

